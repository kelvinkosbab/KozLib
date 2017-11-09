//
//  PresentableController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

enum PresentationMode {
  case modal, modalOverCurrentContext, leftMenu, rightToLeft, fadeWithBlur, overCurrentContext, navStack
}

protocol PresentableController : class {
  var presentedMode: PresentationMode { get set }
  var transitioningDelegateReference: UIViewControllerTransitioningDelegate? { get set }
  var currentFlowFirstController: PresentableController? { get set }
  func present(viewController: UIViewController, withMode mode: PresentationMode, inNavigationController: Bool, dismissInteractiveView: UIView?, completion: (() -> Void)?)
  func dismissController(completion: (() -> Void)?)
  func dismissCurrentNavigationFlow(completion: (() -> Void)?)
}

extension PresentableController where Self : UIViewController {
  
  func present(viewController: UIViewController, withMode mode: PresentationMode, inNavigationController: Bool = true, dismissInteractiveView: UIView? = nil, completion: (() -> Void)? = nil) {
    
    // Configure the view controller to present
    let presentingPresentableController: PresentableController? = viewController as? PresentableController
    presentingPresentableController?.presentedMode = mode
    let viewControllerToPresent: UIViewController = mode != .navStack && inNavigationController ? BaseNavigationController(rootViewController: viewController) : viewController
    let viewControllerToPresentPresentableController: PresentableController? = viewControllerToPresent as? PresentableController
    
    switch mode {
    case .modal:
      presentingPresentableController?.currentFlowFirstController = self
      let viewController = inNavigationController ? UINavigationController(rootViewController: viewControllerToPresent) : viewControllerToPresent
      if UIDevice.current.isPhone {
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalPresentationCapturesStatusBarAppearance = true
      } else {
        viewController.modalPresentationStyle = .formSheet
      }
      self.present(viewController, animated: true, completion: completion)
      break
      
    case .modalOverCurrentContext:
      presentingPresentableController?.currentFlowFirstController = self
      let viewController = inNavigationController ? UINavigationController(rootViewController: viewControllerToPresent) : viewControllerToPresent
      if UIDevice.current.isPhone {
        viewController.modalTransitionStyle = .coverVertical
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalPresentationCapturesStatusBarAppearance = true
      } else {
        viewController.modalPresentationStyle = .overCurrentContext
      }
      self.present(viewController, animated: true, completion: completion)
      break
      
    case .leftMenu:
      presentingPresentableController?.currentFlowFirstController = self
      let presentationManager = LeftMenuPresentationManager(dismissInteractor: DragLeftDismissInteractiveTransition(presentingController: viewControllerToPresent, interactiveView: dismissInteractiveView))
      viewControllerToPresent.modalPresentationStyle = .custom
      viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
      viewControllerToPresent.transitioningDelegate = presentationManager
      viewControllerToPresentPresentableController?.transitioningDelegateReference = presentationManager
      self.present(viewControllerToPresent, animated: true, completion: completion)
      break
      
    case .rightToLeft:
      presentingPresentableController?.currentFlowFirstController = self
      let presentationManager = RightToLeftPresentationManager(dismissInteractor: DragRightDismissInteractiveTransition(presentingController: viewControllerToPresent, interactiveView: dismissInteractiveView))
      viewControllerToPresent.modalPresentationStyle = .custom
      viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
      viewControllerToPresent.transitioningDelegate = presentationManager
      viewControllerToPresentPresentableController?.transitioningDelegateReference = presentationManager
      self.present(viewControllerToPresent, animated: true, completion: completion)
      break
      
    case .fadeWithBlur:
      presentingPresentableController?.currentFlowFirstController = self
      let presentationManager = HDFadeWithBlurPresentationManager()
      viewControllerToPresent.modalPresentationStyle = .custom
      viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
      viewControllerToPresent.transitioningDelegate = presentationManager
      viewControllerToPresentPresentableController?.transitioningDelegateReference = presentationManager
      self.present(viewControllerToPresent, animated: true, completion: completion)
      break
      
    case .overCurrentContext:
      presentingPresentableController?.currentFlowFirstController = self
      let viewController = inNavigationController ? UINavigationController(rootViewController: viewControllerToPresent) : viewControllerToPresent
      viewController.modalPresentationStyle = .overCurrentContext
      viewController.modalTransitionStyle = .crossDissolve
      self.present(viewController, animated: true, completion: completion)
      break
      
    case .navStack:
      self.navigationController?.pushViewController(viewControllerToPresent, animated: true)
      completion?()
      break
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
      break
      
    default:
      self.presentingViewController?.dismiss(animated: true, completion: completion)
      break
    }
  }
  
  func dismissCurrentNavigationFlow(completion: (() -> Void)? = nil) {
    guard let currentFlowFirstController = self.currentFlowFirstController else {
      self.dismissController(completion: completion)
      return
    }
    currentFlowFirstController.dismissController(completion: completion)
  }
}
