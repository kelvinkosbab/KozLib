//
//  UINavigationController+Util.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 3/11/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

extension UINavigationController {
  
  public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
    self.pushViewController(viewController, animated: animated)
    
    guard animated, let coordinator = self.transitionCoordinator else {
      completion()
      return
    }
    
    coordinator.animate(alongsideTransition: nil) { _ in completion() }
  }
  
  public func popToRootViewController(animated: Bool, completion: @escaping () -> Void) {
    self.popToRootViewController(animated: animated)
    
    guard animated, let coordinator = self.transitionCoordinator else {
      completion()
      return
    }
    
    coordinator.animate(alongsideTransition: nil) { _ in completion() }
  }
}
