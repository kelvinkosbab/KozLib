//
//  ARKitNavigationDelegate.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

protocol ARKitNavigationDelegate : class {}
extension ARKitNavigationDelegate where Self : UIViewController {
  
  // MARK: - Horizontal
  
  func transitionToARKitItems(presentationMode: PresentationMode) {
    let viewController = ARKitItemsViewController.newViewController()
    viewController.presentIn(self, withMode: presentationMode)
  }
  
  func transitionToARPlaneVisualization() {
    let viewController = ARPlaneMappingViewController.newViewController()
    viewController.presentIn(self, withMode: .custom(.rightToLeft))
  }
  
  func transitionToARBlockPhysics() {
    let viewController = ARBlockPhysicsViewController.newViewController()
    viewController.presentIn(self, withMode: .custom(.rightToLeft))
  }
  
  func transitionToPlaneMapping() {
    let viewController = ARPlaneMappingViewController.newViewController()
    viewController.presentIn(self, withMode: .custom(.rightToLeft))
  }
  
  func transitionToDragonDemo() {
    let viewController = TackDragonMainViewController.newViewController()
    viewController.presentIn(self, withMode: .custom(.rightToLeft))
  }
  
  // MARK: - Vertical
  
  func transitionToRecognizingImages() {
    let viewController = ARRecognizingImagesViewController.newViewController()
    viewController.presentIn(self, withMode: .custom(.rightToLeft))
  }
  
  func transitionToWallDetection() {
    let viewController = ARWallDetectionViewController.newViewController()
    viewController.presentIn(self, withMode: .custom(.rightToLeft))
  }
  
  // MARK: - Face Tracking
  
  func transitionToARFaceTracking() {
    let viewController = ARFaceTrackingViewController.newViewController()
    viewController.presentIn(self, withMode: .custom(.rightToLeft))
  }
}
