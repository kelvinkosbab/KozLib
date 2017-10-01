//
//  ARKitNavigationDelegate.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

protocol ARKitNavigationDelegate {}
extension ARKitNavigationDelegate where Self : PresentableController {
  
  func transitionToARKitItems(presentationMode: PresentationMode, inNavigationController: Bool = true, dismissInteractiveView: UIView? = nil, completion: (() -> Void)? = nil) {
    let viewController = ARKitItemsViewController.newViewController()
    self.present(viewController: viewController, withMode: presentationMode, inNavigationController: inNavigationController, dismissInteractiveView: dismissInteractiveView, completion: completion)
  }
  
  func transitionToPlaneVisualization() {
    let viewController = ARPlaneMappingViewController.newViewController()
    self.present(viewController: viewController, withMode: .rightToLeft, inNavigationController: true, dismissInteractiveView: viewController.view, completion: nil)
  }
}
