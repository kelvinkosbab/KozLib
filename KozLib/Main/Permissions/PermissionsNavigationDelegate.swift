//
//  PermissionsNavigationDelegate.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

protocol PermissionsNavigationDelegate {}
extension PermissionsNavigationDelegate where Self : PresentableController {
  
  func transitionToPermissions(delegate: PermissionsViewControllerDelegate? = nil) {
    let viewController = PermissionsViewController.newViewController(delegate: delegate)
    self.present(viewController: viewController, withMode: .modal)
  }
}
