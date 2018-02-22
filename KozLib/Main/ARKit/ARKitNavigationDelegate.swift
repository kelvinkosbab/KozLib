//
//  ARKitNavigationDelegate.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

protocol ARKitNavigationDelegate : class {}
extension ARKitNavigationDelegate where Self : PresentableController {
  
  // MARK: - Horizontal
  
  func transitionToARKitItems(presentationMode: PresentationMode) {
    let viewController = ARKitItemsViewController.newViewController()
    self.present(viewController: viewController, withMode: presentationMode, options: [])
  }
  
  func transitionToARPlaneVisualization() {
    let viewController = ARPlaneMappingViewController.newViewController()
    self.present(viewController: viewController, withMode: .custom(.rightToLeft), options: [])
  }
  
  func transitionToARBlockPhysics() {
    let viewController = ARBlockPhysicsViewController.newViewController()
    self.present(viewController: viewController, withMode: .custom(.rightToLeft), options: [])
  }
  
  func transitionToPlaneMapping() {
    let viewController = ARPlaneMappingViewController.newViewController()
    self.present(viewController: viewController, withMode: .custom(.rightToLeft), options: [])
  }
  
  func transitionToDragonDemo() {
    let viewController = TackDragonMainViewController.newViewController()
    self.present(viewController: viewController, withMode: .custom(.rightToLeft), options: [])
  }
  
  // MARK: - Vertical
  
  func transitionToWallDetection() {
    let viewController = ARWallDetectionViewController.newViewController()
    self.present(viewController: viewController, withMode: .custom(.rightToLeft), options: [])
  }
  
  // MARK: - Face Tracking
  
  func transitionToARFaceTracking() {
    let viewController = ARFaceTrackingViewController.newViewController()
    self.present(viewController: viewController, withMode: .custom(.rightToLeft), options: [])
  }
}
