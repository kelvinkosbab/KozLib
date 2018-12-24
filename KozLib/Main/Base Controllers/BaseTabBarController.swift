//
//  BaseTabBarController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 12/23/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class BaseTabBarController : UITabBarController, PresentableController {
  
  // MARK: - PresentableController
  
  var presentedMode: PresentationMode = .modal(.formSheet, .coverVertical)
  var presentationManager: UIViewControllerTransitioningDelegate?
  var currentFlowInitialController: PresentableController?
}
