//
//  UITabBarController+Util.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

extension UITabBarController {
  
  func showTabBar(animated: Bool = true, animating: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    let tabBarFrame = self.tabBar.frame
    let heightOffset = tabBarFrame.size.height
    UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
      let tabBarNewY = tabBarFrame.origin.y - heightOffset
      self.tabBar.frame = CGRect(x: tabBarFrame.origin.x, y: tabBarNewY, width: tabBarFrame.size.width, height: tabBarFrame.size.height)
      animating?()
    }, completion: { (_) in
      self.tabBar.isUserInteractionEnabled = true
      completion?()
    })
  }
  
  func hideTabBar(animated: Bool = true, animating: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    self.tabBar.isUserInteractionEnabled = false
    let tabBarFrame = self.tabBar.frame
    let heightOffset = tabBarFrame.size.height
    UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
      let tabBarNewY = tabBarFrame.origin.y + heightOffset
      self.tabBar.frame = CGRect(x: tabBarFrame.origin.x, y: tabBarNewY, width: tabBarFrame.size.width, height: tabBarFrame.size.height)
      animating?()
    }, completion: { (_) in
      completion?()
    })
  }
}

