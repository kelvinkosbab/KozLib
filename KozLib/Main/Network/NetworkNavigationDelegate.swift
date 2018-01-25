//
//  NetworkInfoNavigationDelegate.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

protocol NetworkNavigationDelegate {}
extension NetworkNavigationDelegate where Self : PresentableController {
  
  func transitionToNetworkInfo(presentationMode: PresentationMode) {
    let viewController = NetworkInfoTableViewController.newViewController()
    self.present(viewController: viewController, withMode: presentationMode)
  }
  
  func transitionToNetworkExtension(presentationMode: PresentationMode) {
    let viewController = NetworkExtensionViewController.newViewController()
    self.present(viewController: viewController, withMode: presentationMode)
  }
}
