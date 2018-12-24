//
//  BottomSheetViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 11/18/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

enum SheetPosition {
  case top, bottom, middle
}

protocol BottomSheetDelegate {
  var bottomSheetInitialBounds: CGRect { get }
  func updateBottomSheet(frame: CGRect)
}

class BottomSheetViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var panView: UIView!
  @IBOutlet weak var tableView: UITableView!
  //    @IBOutlet weak var collectionView: UICollectionView! //header view
  
  var lastY: CGFloat = 0
  var pan: UIPanGestureRecognizer!
  
  var bottomSheetDelegate: BottomSheetDelegate?
  var parentView: UIView!
  
  // Initial position of the sheet
  var sheetPosition: SheetPosition = .top
  
  var initalFrame: CGRect!
  var middleY: CGFloat = 400 //change this in viewDidLayoutSubviews to decide if animate to top or bottom
  var bottomY: CGFloat = 600 //no need to change this
  private var isCompletingAnimation: Bool = false
  
  // Sheet top Y position
  var topY: CGFloat {
    let top = self.view.safeAreaInsets.top
    if top == 0 {
      let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
      let statusBarHeight = UIApplication.shared.statusBarFrame.height
      return navigationBarHeight + statusBarHeight
    }
    return top
  }
  
  // Sheet height on bottom position
  var bottomOffset: CGFloat {
    return 64 + self.view.safeAreaInsets.bottom
  }
  
  var disableTableScroll = false
  
  //hack panOffset To prevent jump when goes from top to down
  var panOffset: CGFloat = 0
  var applyPanOffset = false
  
  //tableview variables
  var listItems: [Any] = []
  var headerItems: [Any] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
    self.pan.delegate = self
    self.panView.addGestureRecognizer(self.pan)
    
    self.tableView.panGestureRecognizer.addTarget(self, action: #selector(self.handlePan(_:)))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Safe Area Updates
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if self.initalFrame == nil {
      self.initalFrame = self.bottomSheetDelegate?.bottomSheetInitialBounds ?? UIScreen.main.bounds
      self.middleY = self.initalFrame.height * 0.5
      self.bottomY = self.initalFrame.height - self.bottomOffset
      switch self.sheetPosition {
      case .top:
        self.lastY = self.topY
      case .middle:
        self.lastY = self.middleY
      case .bottom:
        self.lastY = self.bottomY
      }
      
      self.notifyUpdate(forSheetPosition: self.sheetPosition)
    }
  }
  
  // MARK: - UIScrollViewDelegate
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    guard scrollView == self.tableView else {
      return
    }
    
    if self.parentView.frame.minY > self.topY {
      self.tableView.contentOffset.y = 0
    }
  }
  
  //this stops unintended tableview scrolling while animating to top
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
    guard scrollView == self.tableView else {
      return
    }
    
    if self.disableTableScroll {
      targetContentOffset.pointee = scrollView.contentOffset
      self.disableTableScroll = false
    }
  }
  
  @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
    let dy = recognizer.translation(in: self.parentView).y
    switch recognizer.state {
    case .began:
      self.applyPanOffset = (self.tableView.contentOffset.y > 0)
      
    case .changed:
      
      guard self.tableView.contentOffset.y <= 0 else {
        self.panOffset = dy
        return
      }
      
      if self.tableView.contentOffset.y <= 0 {
        if !self.applyPanOffset {
          self.panOffset = 0
        }
        let maxY = max(self.topY, self.lastY + dy - self.panOffset)
        let y = min(self.bottomY, maxY)
        self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: y))
      }
      
      if self.parentView.frame.minY > self.topY {
        self.tableView.contentOffset.y = 0
      }
      
    case .failed, .ended, .cancelled:
      
      guard !self.isCompletingAnimation else {
        return
      }
      
      self.isCompletingAnimation = true
      
      self.panOffset = 0
      self.panView.isUserInteractionEnabled = false
      
      self.disableTableScroll = self.sheetPosition != .top
      
      self.lastY = self.parentView.frame.minY
      self.sheetPosition = self.getNextSheetPosition(recognizer: recognizer)
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: .curveEaseOut, animations: { [weak self] in
        
        guard let strongSelf = self else {
          return
        }
        
        strongSelf.notifyUpdate(forSheetPosition: strongSelf.sheetPosition)
        
      }) { [weak self] _ in
        
        guard let strongSelf = self else {
          return
        }
        
        strongSelf.panView.isUserInteractionEnabled = true
        strongSelf.lastY = strongSelf.parentView.frame.minY
        strongSelf.isCompletingAnimation = false
      }
      
    default: break
    }
  }
  
  private func getNextSheetPosition(recognizer: UIPanGestureRecognizer) -> SheetPosition {
    let y = self.lastY
    let yVelocity = recognizer.velocity(in: self.view).y
    if yVelocity < -300 {
      let lastSheetPosition = self.sheetPosition
      switch lastSheetPosition {
      case .top, .middle:
        return abs(y - self.middleY) < 70 ? .middle : .top
      case .bottom:
        return .middle
      }
    } else if yVelocity > 300 {
      let lastSheetPosition = self.sheetPosition
      switch lastSheetPosition {
      case .top:
        return abs(y - self.bottomY) < 70 ? .bottom : .middle
      case .middle, .bottom:
        return .bottom
      }
    } else {
      if y > self.middleY {
        return (y - self.middleY) < (self.bottomY - y) ? .middle : .bottom
      } else {
        return (y - self.topY) < (self.middleY - y) ? .top : .middle
      }
    }
  }
  
  private func notifyUpdate(forSheetPosition sheetPosition: SheetPosition) {
    switch self.sheetPosition {
    case .top:
      self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.topY))
      self.tableView.contentInset.bottom = 50
      self.tableView.alpha = 1
      
    case .middle:
      self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.middleY))
      self.tableView.alpha = 1
      
    case .bottom:
      self.bottomSheetDelegate?.updateBottomSheet(frame: self.initalFrame.offsetBy(dx: 0, dy: self.bottomY))
      self.tableView.alpha = 0
    }
  }
  
  // MARK: - Keyboard
  
  @objc func keyboardWillChange(notification: NSNotification) {
    
    guard let userInfo = notification.userInfo, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double, let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt, let curFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, let targetFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
      return
    }
    
    let deltaY = targetFrame.origin.y - curFrame.origin.y
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
  }
  
  @objc func keyboardWillHide(notification: NSNotification){
  }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

//extension BottomSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 8
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topCell", for: indexPath)
//        return cell
//    }
//}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension BottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableCell", for: indexPath) as! SimpleTableCell
    let model = SimpleTableCellViewModel(image: nil, title: "Title \(indexPath.row)", subtitle: "Subtitle \(indexPath.row)")
    cell.configure(model: model)
    return cell
  }
}

// MARK: - UIGestureRecognizerDelegate

extension BottomSheetViewController: UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
