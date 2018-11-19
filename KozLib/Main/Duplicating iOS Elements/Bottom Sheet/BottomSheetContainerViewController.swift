//
//  BottomSheetContainerViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 11/18/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class BottomSheetContainerViewController : BaseViewController {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> BottomSheetContainerViewController {
    return self.newViewController(fromStoryboardWithName: "BottomSheet")
  }
  
  // MARK: - Property Outlets
  
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var container: UIView!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Pull Up Controller"
    self.configureDefaultBackButton()
    self.baseNavigationController?.navigationBarStyle = .transparent
    self.navigationItem.largeTitleDisplayMode = .never
    switch self.presentedMode {
    case .navStack:
      self.navigationItem.leftBarButtonItem = nil
    default:
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.backButtonSelected))
    }
    
    self.container.layer.cornerRadius = 15
    self.container.layer.masksToBounds = true
  }
  
  // MARK: - Status Bar
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let viewController = segue.destination as? BottomSheetViewController {
      viewController.bottomSheetDelegate = self
      viewController.parentView = self.container
    }
  }
  
  // MARK: - Actions
  
  @objc func backButtonSelected() {
    self.dismissController()
  }
}

// MARK: - BottomSheetDelegate

extension BottomSheetContainerViewController : BottomSheetDelegate {
  
  var bottomSheetInitialBounds: CGRect {
    return self.view.bounds
  }
  
  func updateBottomSheet(frame: CGRect) {
    self.container.frame = frame
  }
}
