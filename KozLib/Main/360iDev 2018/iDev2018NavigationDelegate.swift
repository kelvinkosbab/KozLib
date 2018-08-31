//
//  iDev2018NavigationDelegate.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 8/30/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

protocol iDev2018NavigationDelegate : class {}
extension iDev2018NavigationDelegate where Self : UIViewController {
  
  func iDev_presentBadgeViewAnimations() {
    let viewController = iDev2018_BadgeViewLayerAnimationsViewController.newViewController()
    viewController.presentIn(self, withMode: .navStack)
  }
  
  func iDev_presentCustomLayoutGraphing() {
    let viewController = iDev2018_GraphViewController.newViewController()
    viewController.presentIn(self, withMode: .navStack)
  }
}
