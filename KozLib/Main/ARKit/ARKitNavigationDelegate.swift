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
  
  // MARK: - Horizontal
  
  func transitionToARKitItems(presentationMode: PresentationMode) {
    let viewController = ARKitItemsViewController.newViewController()
    self.present(viewController: viewController, withMode: presentationMode)
  }
  
  func transitionToARPlaneVisualization() {
    let viewController = ARPlaneMappingViewController.newViewController()
    let interactiveElement = InteractiveElement(size: nil, offset: nil, view: viewController.view)
    self.present(viewController: viewController, withMode: .rightToLeft, options: [ .dismissInteractiveElement(interactiveElement) ], completion: nil)
  }
  
  func transitionToARBlockPhysics() {
    let viewController = ARBlockPhysicsViewController.newViewController()
    let interactiveElement = InteractiveElement(size: nil, offset: nil, view: viewController.view)
    self.present(viewController: viewController, withMode: .rightToLeft, options: [ .dismissInteractiveElement(interactiveElement) ], completion: nil)
  }
  
  func transitionToPlaneMapping() {
    let viewController = ARPlaneMappingViewController.newViewController()
    let interactiveElement = InteractiveElement(size: nil, offset: nil, view: viewController.view)
    self.present(viewController: viewController, withMode: .rightToLeft, options: [ .dismissInteractiveElement(interactiveElement) ], completion: nil)
  }
  
  func transitionToDragonDemo() {
    let viewController = TackDragonMainViewController.newViewController()
    let interactiveElement = InteractiveElement(size: nil, offset: nil, view: viewController.view)
    self.present(viewController: viewController, withMode: .rightToLeft, options: [ .dismissInteractiveElement(interactiveElement) ], completion: nil)
  }
  
  // MARK: - Vertical
  
  func transitionToWallDetection() {
    let viewController = ARWallDetectionViewController.newViewController()
    let interactiveElement = InteractiveElement(size: nil, offset: nil, view: viewController.view)
    self.present(viewController: viewController, withMode: .rightToLeft, options: [ .dismissInteractiveElement(interactiveElement) ], completion: nil)
  }
  
  // MARK: - Face Tracking
  
  func transitionToARFaceTracking() {
    let viewController = ARFaceTrackingViewController.newViewController()
    let interactiveElement = InteractiveElement(size: nil, offset: nil, view: viewController.view)
    self.present(viewController: viewController, withMode: .rightToLeft, options: [ .dismissInteractiveElement(interactiveElement) ], completion: nil)
  }
}
