//
//  BaseNavigationController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class BaseNavigationController : UINavigationController, PresentableController {
  
  // MARK: - PresentableController
  
  var presentedMode: PresentationMode = .modal
  var transitioningDelegateReference: UIViewControllerTransitioningDelegate? = nil
  var currentFlowFirstController: PresentableController? = nil
  
  // MARK: - NavigationBarStyle
  
  enum NavigationBarStyle {
    case standard, transparent
    
    var isTranslucent: Bool {
      switch self {
      case .standard:
        return false
      case .transparent:
        return true
      }
    }
    
    var barTintColor: UIColor {
      switch self {
      case .standard:
        return .white
      case .transparent:
        return .clear
      }
    }
    
    var tintColor: UIColor {
      switch self {
      case .standard:
        return .blue
      case .transparent:
        return .white
      }
    }
    
    var titleTextAttributes: [NSAttributedStringKey : Any]? {
      switch self {
      case .standard:
        return [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.black ]
      case .transparent:
        return [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.white ]
      }
    }
    
    var backIndicator: UIImage? {
      switch self {
      default:
        return nil
      }
    }
    
    var backItemTitle: String {
      switch self {
      default:
        return ""
      }
    }
  }
  
  convenience init(navigationBarStyle: NavigationBarStyle) {
    self.init()
    
    self.navigationBarStyle = navigationBarStyle
  }
  
  var navigationBarStyle: NavigationBarStyle = .standard {
    didSet {
      if self.navigationBarStyle != oldValue {
        self.applyNavigationBarStyles()
      }
    }
  }
  
  private func applyNavigationBarStyles() {
    
    // Title and tint
    self.navigationBar.barTintColor = self.navigationBarStyle.barTintColor
    self.navigationBar.tintColor = self.navigationBarStyle.tintColor
    self.navigationBar.titleTextAttributes = self.navigationBarStyle.titleTextAttributes
    self.navigationBar.isTranslucent = self.navigationBarStyle.isTranslucent
    
    // Back button
    //self.navigationBar.backIndicatorImage = self.navigationBarStyle.backIndicator
    //self.navigationBar.backIndicatorTransitionMaskImage = self.navigationBarStyle.backIndicator
    //self.navigationBar.backItem?.title = "Back"
    
    switch self.navigationBarStyle {
    case .transparent:
      self.navigationBar.setBackgroundImage(UIImage(), for: .default)
      self.navigationBar.shadowImage = UIImage()
      self.navigationBar.backgroundColor = .clear
      break
    default:
      break
    }
    
    // Update the status bar
    self.setNeedsStatusBarAppearanceUpdate()
  }
  
  // MARK: - Status Bar Style
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    switch self.navigationBarStyle {
    case .standard:
      return .default
    case .transparent:
      return .lightContent
    }
  }
}
