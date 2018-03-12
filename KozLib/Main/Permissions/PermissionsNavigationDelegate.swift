//
//  PermissionsNavigationDelegate.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

protocol PermissionsNavigationDelegate : class {}
extension PermissionsNavigationDelegate where Self : UIViewController {
  
  func transitionToPermissions(delegate: PermissionsViewControllerDelegate? = nil) {
    let viewController = PermissionsViewController.newViewController(delegate: delegate)
    viewController.presentIn(self, withMode: .modal(.formSheet, .coverVertical))
  }
}
