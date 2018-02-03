//
//  PresentableController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

// MARK: - InteractiveElement

struct InteractiveElement {
  let size: CGFloat?
  let offset: CGFloat?
  let view: UIView
}

// MARK: - PresentableControllerOption

enum PresentableControllerOption {
  case withoutNavigationController, dismissInteractiveElement(InteractiveElement)
}

extension Sequence where Iterator.Element == PresentableControllerOption {
  
  var inNavigationController: Bool {
    return !self.contains { option -> Bool in
      switch option {
      case .withoutNavigationController:
        return true
      default:
        return false
      }
    }
  }
  
  var dismissInteractiveElement: InteractiveElement? {
    for option in self {
      switch option {
      case .dismissInteractiveElement(let interactiveElement):
        return interactiveElement
      default: break
      }
    }
    return nil
  }
}

// MARK: - PresentationMode

enum PresentationMode {
  case modal, modalOverCurrentContext, leftMenu, rightToLeft, fadeWithBlur, overCurrentContext, topDown, bottomUp, navStack
}

// MARK: - PresentableController

protocol PresentableController : class {
  var presentedMode: PresentationMode { get set }
  var transitioningDelegateReference: UIViewControllerTransitioningDelegate? { get set }
  var currentFlowFirstController: PresentableController? { get set }
  func present(viewController: UIViewController, withMode mode: PresentationMode)
  func present(viewController: UIViewController, withMode mode: PresentationMode, completion: (() -> Void)?)
  func present(viewController: UIViewController, withMode mode: PresentationMode, options: [PresentableControllerOption])
  func present(viewController: UIViewController, withMode mode: PresentationMode, options: [PresentableControllerOption], completion: (() -> Void)?)
  func dismissController(completion: (() -> Void)?)
  func dismissCurrentNavigationFlow(completion: (() -> Void)?)
}

extension PresentableController where Self : UIViewController {
  
  func present(viewController: UIViewController, withMode mode: PresentationMode) {
    self.present(viewController: viewController, withMode: mode, options: [], completion: nil)
  }
  
  func present(viewController: UIViewController, withMode mode: PresentationMode, completion: (() -> Void)?) {
    self.present(viewController: viewController, withMode: mode, options: [], completion: completion)
  }
  
  func present(viewController: UIViewController, withMode mode: PresentationMode, options: [PresentableControllerOption]) {
    self.present(viewController: viewController, withMode: mode, options: options, completion: nil)
  }
  
  func present(viewController: UIViewController, withMode mode: PresentationMode, options: [PresentableControllerOption], completion: (() -> Void)?) {
    
    // Handle options
    let inNavigationController = options.inNavigationController
    let dismissInteractiveElement: InteractiveElement? = options.dismissInteractiveElement
    
    // Configure the view controller to present
    let presentingPresentableController: PresentableController? = viewController as? PresentableController
    presentingPresentableController?.presentedMode = mode
    let viewControllerToPresent: UIViewController = mode != .navStack && inNavigationController ? BaseNavigationController(rootViewController: viewController) : viewController
    let viewControllerToPresentPresentableController: PresentableController? = viewControllerToPresent as? PresentableController
    
    switch mode {
    case .modal:
      presentingPresentableController?.currentFlowFirstController = self
      if UIDevice.current.isPhone {
        viewControllerToPresent.modalTransitionStyle = .coverVertical
        viewControllerToPresent.modalPresentationStyle = .overFullScreen
        viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
      } else {
        viewControllerToPresent.modalPresentationStyle = .formSheet
      }
      self.present(viewControllerToPresent, animated: true, completion: completion)
      
    case .modalOverCurrentContext:
      presentingPresentableController?.currentFlowFirstController = self
      if UIDevice.current.isPhone {
        viewControllerToPresent.modalTransitionStyle = .coverVertical
        viewControllerToPresent.modalPresentationStyle = .overFullScreen
        viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
      } else {
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
      }
      self.present(viewControllerToPresent, animated: true, completion: completion)
      
    case .leftMenu:
      presentingPresentableController?.currentFlowFirstController = self
      _ = DragLeftDismissInteractiveTransition(presentingController: viewControllerToPresent, interactiveView: dismissInteractiveElement?.view)
      let presentationManager = LeftMenuPresentationManager(dismissInteractor: DragLeftDismissInteractiveTransition(presentingController: viewControllerToPresent, interactiveView: dismissInteractiveElement?.view))
      viewControllerToPresent.modalPresentationStyle = .custom
      viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
      viewControllerToPresent.transitioningDelegate = presentationManager
      viewControllerToPresentPresentableController?.transitioningDelegateReference = presentationManager
      self.present(viewControllerToPresent, animated: true, completion: completion)
      
    case .rightToLeft:
      presentingPresentableController?.currentFlowFirstController = self
      let presentationManager = RightToLeftPresentationManager(dismissInteractor: DragRightDismissInteractiveTransition(presentingController: viewControllerToPresent, interactiveView: dismissInteractiveElement?.view))
      viewControllerToPresent.modalPresentationStyle = .custom
      viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
      viewControllerToPresent.transitioningDelegate = presentationManager
      viewControllerToPresentPresentableController?.transitioningDelegateReference = presentationManager
      self.present(viewControllerToPresent, animated: true, completion: completion)
      
    case .fadeWithBlur:
      presentingPresentableController?.currentFlowFirstController = self
      let presentationManager = HDFadeWithBlurPresentationManager()
      viewControllerToPresent.modalPresentationStyle = .custom
      viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
      viewControllerToPresent.transitioningDelegate = presentationManager
      viewControllerToPresentPresentableController?.transitioningDelegateReference = presentationManager
      self.present(viewControllerToPresent, animated: true, completion: completion)
      
    case .overCurrentContext:
      presentingPresentableController?.currentFlowFirstController = self
      let viewController = inNavigationController ? BaseNavigationController(rootViewController: viewControllerToPresent) : viewControllerToPresent
      viewController.modalPresentationStyle = .overCurrentContext
      viewController.modalTransitionStyle = .crossDissolve
      self.present(viewController, animated: true, completion: completion)
      
    case .topDown:
      presentingPresentableController?.currentFlowFirstController = self
      let presentationManager = TopDownPresentationManager(interactiveElement: dismissInteractiveElement, dismissInteractor: DragUpDismissInteractiveTransition(presentingController: viewControllerToPresent, interactiveView: dismissInteractiveElement?.view))
      viewControllerToPresent.modalPresentationStyle = .custom
      viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
      viewControllerToPresent.transitioningDelegate = presentationManager
      viewControllerToPresentPresentableController?.transitioningDelegateReference = presentationManager
      self.present(viewControllerToPresent, animated: true, completion: completion)
      
    case .bottomUp:
      presentingPresentableController?.currentFlowFirstController = self
      let presentationManager = BottomUpPresentationManager(interactiveElement: dismissInteractiveElement, dismissInteractor: DragDownDismissInteractiveTransition(presentingController: viewControllerToPresent, interactiveView: dismissInteractiveElement?.view))
      viewControllerToPresent.modalPresentationStyle = .custom
      viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
      viewControllerToPresent.transitioningDelegate = presentationManager
      viewControllerToPresentPresentableController?.transitioningDelegateReference = presentationManager
      self.present(viewControllerToPresent, animated: true, completion: completion)
      
    case .navStack:
      self.navigationController?.pushViewController(viewControllerToPresent, animated: true)
      completion?()
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
    guard let currentFlowFirstController = self.currentFlowFirstController else {
      self.dismissController(completion: completion)
      return
    }
    currentFlowFirstController.dismissController(completion: completion)
  }
}
