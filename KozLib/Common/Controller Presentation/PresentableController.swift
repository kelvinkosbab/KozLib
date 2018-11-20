//
//  PresentableController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 10/30/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

protocol PresentableController : class {
  var presentedMode: PresentationMode { get set }
  var presentationManager: UIViewControllerTransitioningDelegate? { get set }
  var currentFlowInitialController: PresentableController? { get set }
  func dismissController(completion: (() -> Void)?)
  func dismissCurrentNavigationFlow(completion: (() -> Void)?)
}

extension PresentableController where Self : UIViewController {
  
  func presentIn(_ presentingViewController: UIViewController, withMode mode: PresentationMode, options: [PresentableControllerOption] = []) {
    
    // Configure the view controller to present
    let viewControllerToPresent: UIViewController = mode.isNavStack ? self : options.inNavigationController ? BaseNavigationController(rootViewController: self) : self
    
    // Configure the initial flow controller
    self.presentedMode = mode
    if !mode.isNavStack {
      self.currentFlowInitialController = self
    }
    
    // Present the controller
    switch mode {
    case .modal(let presentationStyle, let transitionStyle):
      viewControllerToPresent.modalPresentationStyle = presentationStyle
      viewControllerToPresent.modalTransitionStyle = transitionStyle
      viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
      presentingViewController.present(viewControllerToPresent, animated: true, completion: nil)
      
    case .custom(let customPresentationMode):
      viewControllerToPresent.modalPresentationStyle = .custom
      viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
      
      // Configure the presenation manager
      let presentationManager = CustomPresentationManager(mode: customPresentationMode)
      presentationManager.presentingViewControllerDelegate = options.presentingViewControllerDelegate
      presentationManager.presentedViewControllerDelegate = options.presentedViewControllerDelegate
      viewControllerToPresent.transitioningDelegate = presentationManager
      if let presentedPresentableController = viewControllerToPresent as? PresentableController {
        presentedPresentableController.presentationManager = presentationManager
      }
      presentingViewController.present(viewControllerToPresent, animated: true, completion: nil)
      
    case .navStack:
      presentingViewController.navigationController?.pushViewController(viewControllerToPresent, animated: true)
    }
  }
  
  func dismissController(completion: (() -> Void)? = nil) {
    switch self.presentedMode {
    case .navStack:
      
      guard let navigationController = self.navigationController, let index = navigationController.viewControllers.index(of: self), index > 0 else {
        self.presentingViewController?.dismiss(animated: true, completion: completion)
        return
      }
      
      // Pop to the controller before this one
      let viewControllerToPopTo = navigationController.viewControllers[index - 1]
      navigationController.popToViewController(viewControllerToPopTo, animated: true)
      
    default:
      self.presentingViewController?.dismiss(animated: true, completion: completion)
    }
  }
  
  func dismissCurrentNavigationFlow(completion: (() -> Void)? = nil) {
    guard let currentFlowInitialController = self.currentFlowInitialController else {
      self.dismissController(completion: completion)
      return
    }
    currentFlowInitialController.dismissController(completion: completion)
  }
  
  // MARK: - Utilities
  
  func configureLargeTitleBasedOnPresentedMode() {
    if #available(iOS 11.0, *) {
      switch self.presentedMode {
      case .navStack:
        self.configureSmallNavigationTitle()
      default:
        self.configureLargeNavigationTitle()
      }
    }
  }
  
  func configureLargeNavigationTitle() {
    if #available(iOS 11.0, *) {
      self.navigationItem.largeTitleDisplayMode = .always
    }
  }
  
  func configureSmallNavigationTitle() {
    if #available(iOS 11.0, *) {
      self.navigationItem.largeTitleDisplayMode = .never
    }
  }
}
