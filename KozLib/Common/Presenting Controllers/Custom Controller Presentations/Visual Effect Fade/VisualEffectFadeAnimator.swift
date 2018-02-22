//
//  VisualEffectFadeAnimator.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class VisualEffectFadeAnimator : NSObject, PresentableAnimator {
  
  // MARK: - PresentableAnimator
  
  weak var presentingViewControllerDelegate: PresentingViewControllerDelegate?
  weak var presentedViewControllerDelegate: PresentedViewControllerDelegate?
  
  // MARK: - UIViewControllerAnimatedTransitioning
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    guard let toViewController = transitionContext.viewController(forKey: .to), let fromViewController = transitionContext.viewController(forKey: .from) else {
      return
    }
    
    let isPresenting = toViewController.presentedViewController != fromViewController
    _ = isPresenting ? fromViewController : toViewController
    let presentedViewController = isPresenting ? toViewController : fromViewController
    let containerView = transitionContext.containerView
    
    if isPresenting {
      
      // Currently presenting
      self.presentingViewControllerDelegate?.willPresentViewController(presentedViewController)
      self.presentedViewControllerDelegate?.willPresentViewController()
      presentedViewController.view.backgroundColor = .clear
      presentedViewController.view.alpha = 0
      presentedViewController.view.addToContainer(containerView)
      UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
        presentedViewController.view.alpha = 1
        self.presentingViewControllerDelegate?.isPresentingViewController(presentedViewController)
        self.presentedViewControllerDelegate?.isPresentingViewController()
      }, completion: { _ in
        self.presentingViewControllerDelegate?.didPresentViewController(presentedViewController)
        self.presentedViewControllerDelegate?.isPresentingViewController()
        transitionContext.completeTransition(true)
      })
      
    } else {
      
      // Currently not presenting
      self.presentingViewControllerDelegate?.willDismissViewController(presentedViewController)
      self.presentedViewControllerDelegate?.willDismissViewController()
      UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
        presentedViewController.view.alpha = 0
        self.presentingViewControllerDelegate?.isDismissingViewController(presentedViewController)
        self.presentedViewControllerDelegate?.isDismissingViewController()
      }, completion: { _ in
        if transitionContext.transitionWasCancelled {
          self.presentingViewControllerDelegate?.didCancelDissmissViewController(presentedViewController)
          self.presentedViewControllerDelegate?.didCancelDissmissViewController()
        } else {
          self.presentingViewControllerDelegate?.didDismissViewController(presentedViewController)
          self.presentedViewControllerDelegate?.didDismissViewController()
        }
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
    }
  }
}
