//
//  ConfigurationViewPresentable.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

protocol ConfigurationViewPresentable : class {}
extension ConfigurationViewPresentable where Self : UIViewController {
  
  var configuringViewController: ConfiguringViewController? {
    for childViewController in self.childViewControllers {
      if let configuringViewController = childViewController as? ConfiguringViewController {
        return configuringViewController
      }
    }
    return nil
  }
  
  func showConfiguringView(_ state: ConfiguringState, animating: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    
    // Check if already showing the configuring view
    if let configuringViewController = self.configuringViewController {
      configuringViewController.state = state
      animating?()
      completion?()
      return
    }
    
    // Create the configuring view
    let configuringViewController = ConfiguringViewController.newViewController(state: state)
    self.add(childViewController: configuringViewController, intoContainerView: self.view)
    configuringViewController.mainContentView?.alpha = 0
    configuringViewController.visualEffectView?.effect = nil
    
    // Animate show the configuring view
    UIView.animate(withDuration: 0.3, animations: { [weak configuringViewController] in
      configuringViewController?.mainContentView?.alpha = 1
      configuringViewController?.visualEffectView?.effect = UIBlurEffect(style: .dark)
      animating?()
    }) { _ in
      completion?()
    }
  }
  
  func hideConfiguringView(animating: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    
    guard let _ = self.configuringViewController else {
      animating?()
      completion?()
      return
    }
    
    // Animate hide the configuring view
    let duration: TimeInterval = 0.3
    UIView.animate(withDuration: duration, animations: { [weak self] in
      self?.configuringViewController?.mainContentView?.alpha = 0
      self?.configuringViewController?.visualEffectView = nil
      animating?()
    }) { [weak self] _ in
      if let configuringViewController = self?.configuringViewController {
        self?.remove(childViewController: configuringViewController)
      }
      completion?()
    }
  }
}
