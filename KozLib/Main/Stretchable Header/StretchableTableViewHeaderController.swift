//
//  StretchableTableViewHeaderController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 12/23/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

/**
 * Source: https://medium.freecodecamp.org/tutorial-creating-stretchy-layouts-on-ios-using-auto-layout-3fa974fa5e28
 */

class StretchableHeaderController : BaseViewController {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> StretchableHeaderController {
    return self.newViewController(fromStoryboardWithName: "StretchableHeader")
  }
  
  // MARK: - View Properties
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var imageContainerView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textContainer: UIView!
  @IBOutlet weak var infoLabel: UILabel!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure navigation bar
    self.title = nil
    self.configureDefaultBackButton()
    self.configureSmallNavigationTitle()
    
    switch self.presentedMode {
    case .navStack: break
    default:
      self.baseNavigationController?.navigationBarStyle = .transparent
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(text: "Done", style: .done(.white), target: self, action: #selector(self.doneButtonSelected))
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    // We want the scroll indicators to use all safe area insets
    self.scrollView.scrollIndicatorInsets = self.view.safeAreaInsets
    
    // But we want the actual content inset to just respect the bottom safe inset
    self.scrollView.contentInset = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0, bottom: self.view.safeAreaInsets.bottom, right: 0)
  }
  
  // MARK: - Actions
  
  @objc func doneButtonSelected() {
    self.dismissController()
  }
  
  // MARK: - UIScrollViewDelegate
  
  private var previousStatusBarHidden = false
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // We keep the previous status bar hidden state so that we’re not triggering an implicit animation block for every frame in which the scroll view scrolls
    if self.previousStatusBarHidden != self.shouldHideStatusBar {
      UIView.animate(withDuration: 0.2, animations: {
        self.setNeedsStatusBarAppearanceUpdate()
      })
      self.previousStatusBarHidden = self.shouldHideStatusBar
    }
  }
  
  // MARK: — Status Bar Appearance
  
  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    // We use the slide animation because it works well with scrolling
    return .slide
  }
  
  override var prefersStatusBarHidden: Bool {
    return self.shouldHideStatusBar
  }
  
  private var shouldHideStatusBar: Bool {
    // Here’s where we calculate if our text container is going to hit the top safe area
    let frame = self.textContainer.convert(self.textContainer.bounds, to: nil)
    return frame.minY < view.safeAreaInsets.top
  }
}
