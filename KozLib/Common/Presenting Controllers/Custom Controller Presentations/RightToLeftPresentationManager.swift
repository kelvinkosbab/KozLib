//
//  RightToLeftPresentationManager.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class RightToLeftPresentationManager : NSObject, UIViewControllerTransitioningDelegate, PresenationManagerProtocol {
  
  // MARK: - MyPresenationManager
  
  var presentationInteractor: InteractiveTransition? = nil
  var dismissInteractor: InteractiveTransition? = nil
  
  required override init() {
    super.init()
  }
  
  required init(presentationInteractor: InteractiveTransition, dismissInteractor: InteractiveTransition) {
    self.presentationInteractor = presentationInteractor
    self.dismissInteractor = dismissInteractor
    super.init()
  }
  
  required init(presentationInteractor: InteractiveTransition) {
    self.presentationInteractor = presentationInteractor
    super.init()
  }
  
  required init(dismissInteractor: InteractiveTransition) {
    self.dismissInteractor = dismissInteractor
    super.init()
  }
  
  // MARK: - UIViewControllerTransitioningDelegate
  
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return RightToLeftPresentationController(presentedViewController: presented, presenting: source)
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return RightToLeftAnimator()
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return RightToLeftAnimator()
  }
  
  func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    if let presentationInteractor = self.presentationInteractor {
      return presentationInteractor.hasStarted ? presentationInteractor : nil
    }
    return nil
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    if let dismissInteractor = self.dismissInteractor {
      return dismissInteractor.hasStarted ? dismissInteractor : nil
    }
    return nil
  }
  
  // MARK: - Animator
  
  class RightToLeftAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      
      guard let toViewController = transitionContext.viewController(forKey: .to), let fromViewController = transitionContext.viewController(forKey: .from) else {
        return
      }
      
      let isUnwinding = toViewController.presentedViewController == fromViewController
      let isPresenting = !isUnwinding
      
      let presentingViewController = isPresenting ? fromViewController : toViewController
      let presentedViewController = isPresenting ? toViewController : fromViewController
      let containerView = transitionContext.containerView
      
      if isPresenting {
        
        // Currently presenting
        presentedViewController.view.frame.origin.x = containerView.frame.width
        containerView.addSubview(presentedViewController.view)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
          presentedViewController.view.frame.origin.x -= containerView.frame.width
          presentingViewController.setNeedsStatusBarAppearanceUpdate()
          presentedViewController.setNeedsStatusBarAppearanceUpdate()
        }, completion: { (_) in
          transitionContext.completeTransition(true)
        })
        
      } else {
        
        // Currently not presenting
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
          presentedViewController.view.frame.origin.x += containerView.frame.width
          presentingViewController.setNeedsStatusBarAppearanceUpdate()
          presentedViewController.setNeedsStatusBarAppearanceUpdate()
        }, completion: { (_) in
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
      }
    }
  }
  
  // MARK: - Presentation Controller
  
  class RightToLeftPresentationController : UIPresentationController {
    
    // MARK: - UIPresentationController
    
    override func presentationTransitionWillBegin() {
      
      guard let _ = self.containerView else {
        return
      }
      
      // Begin animation
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
      }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
      }, completion: nil)
    }
    
    override var shouldPresentInFullscreen: Bool {
      return true
    }
  }
}
