//
//  NetworkInfoNavigationDelegate.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

protocol NetworkInfoNavigationDelegate {}
extension NetworkInfoNavigationDelegate where Self : PresentableController {
  
  func transitionToNetworkInfo(presentationMode: PresentationMode, inNavigationController: Bool = true, dismissInteractiveView: UIView? = nil, completion: (() -> Void)? = nil) {
    let viewController = NetworkInfoTableViewController.newViewController()
    self.present(viewController: viewController, withMode: presentationMode, inNavigationController: inNavigationController, dismissInteractiveView: dismissInteractiveView, completion: completion)
  }
}
