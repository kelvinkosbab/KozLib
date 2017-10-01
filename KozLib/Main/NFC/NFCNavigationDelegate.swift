//
//  NFCNavigationDelegate.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

protocol NFCNavigationDelegate {}
extension NFCNavigationDelegate where Self : PresentableController {
  
  func transitionToNFC(presentationMode: PresentationMode, inNavigationController: Bool = true, dismissInteractiveView: UIView? = nil, completion: (() -> Void)? = nil) {
    let viewController = NFCTableViewController.newViewController()
    self.present(viewController: viewController, withMode: presentationMode, inNavigationController: inNavigationController, dismissInteractiveView: dismissInteractiveView, completion: completion)
  }
}
