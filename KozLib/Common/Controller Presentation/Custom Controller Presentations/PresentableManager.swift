//
//  PresentableManager.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

protocol PresentableManager : UIViewControllerTransitioningDelegate {
  var presentationController: CustomPresentationController? { get set }
  var presentingViewControllerDelegate: PresentingViewControllerDelegate? { get set }
  var presentedViewControllerDelegate: PresentedViewControllerDelegate? { get set }
}

extension PresentableManager {
  
  var presentationInteractiveTransition: InteractiveTransition? {
    return self.presentationController?.presentationInteractiveTransition
  }
  
  var dismissInteractiveTransition: InteractiveTransition? {
    return self.presentationController?.dismissInteractiveTransition
  }
}

// MARK: - CustomPresentationManager

class CustomPresentationManager : NSObject, PresentableManager {
  
  // MARK: - Init
  
  init(mode customPresentationMode: CustomPresentationMode) {
    self.customPresentationMode = customPresentationMode
    super.init()
  }
  
  // MARK: - PresentableManager
  
  let customPresentationMode: CustomPresentationMode
  
  var presentationController: CustomPresentationController?
  
  weak var presentingViewControllerDelegate: PresentingViewControllerDelegate?
  weak var presentedViewControllerDelegate: PresentedViewControllerDelegate?
  
  // MARK: - UIViewControllerTransitioningDelegate
  
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let presentationController = self.customPresentationMode.getPresentationController(forPresented: presented, presenting: source)
    self.presentationController = presentationController
    return presentationController
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let animator = self.customPresentationMode.presentationAnimator
    animator.presentingViewControllerDelegate = self.presentingViewControllerDelegate
    animator.presentedViewControllerDelegate = self.presentedViewControllerDelegate
    return animator
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let animator = self.customPresentationMode.dissmissAnimator
    animator.presentingViewControllerDelegate = self.presentingViewControllerDelegate
    animator.presentedViewControllerDelegate = self.presentedViewControllerDelegate
    return animator
  }
  
  func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    if let presentationInteractiveTransition = self.presentationInteractiveTransition, presentationInteractiveTransition.hasStarted {
      return presentationInteractiveTransition
    }
    return nil
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    if let dismissInteractiveTransition = self.dismissInteractiveTransition, dismissInteractiveTransition.hasStarted {
      return dismissInteractiveTransition
    }
    return nil
  }
}
