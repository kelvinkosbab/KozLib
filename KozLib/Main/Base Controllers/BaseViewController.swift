//
//  BaseViewController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController, PresentableController {
  
  // MARK: - PresentableController
  
  var presentedMode: PresentationMode = .modal
  var transitioningDelegateReference: UIViewControllerTransitioningDelegate? = nil
  var currentFlowFirstController: PresentableController? = nil
}
