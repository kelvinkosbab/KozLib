//
//  RightToLeftAnimator.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class RightToLeftAnimator : NSObject, PresentableAnimator {
  
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
      self.presentingViewControllerDelegate?.willPresentViewController(presentedViewController, usingMode: .custom(.rightToLeft))
      self.presentedViewControllerDelegate?.willPresentViewController(usingMode: .custom(.rightToLeft))
      presentedViewController.view.frame.origin.x = containerView.frame.width
      containerView.addSubview(presentedViewController.view)
      UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
        presentedViewController.view.frame.origin.x -= containerView.frame.width
        self.presentingViewControllerDelegate?.isPresentingViewController(presentedViewController, usingMode: .custom(.rightToLeft))
        self.presentedViewControllerDelegate?.isPresentingViewController(usingMode: .custom(.rightToLeft))
      }, completion: { _ in
        self.presentingViewControllerDelegate?.didPresentViewController(presentedViewController, usingMode: .custom(.rightToLeft))
        self.presentedViewControllerDelegate?.didPresentViewController(usingMode: .custom(.rightToLeft))
        transitionContext.completeTransition(true)
      })
      
    } else {
      
      // Currently dismissing
      self.presentingViewControllerDelegate?.willDismissViewController(presentedViewController, usingMode: .custom(.rightToLeft))
      self.presentedViewControllerDelegate?.willDismissViewController(usingMode: .custom(.rightToLeft))
      UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
        presentedViewController.view.frame.origin.x += containerView.frame.width
        self.presentingViewControllerDelegate?.isDismissingViewController(presentedViewController, usingMode: .custom(.rightToLeft))
        self.presentedViewControllerDelegate?.isDismissingViewController(usingMode: .custom(.rightToLeft))
      }, completion: { _ in
        if transitionContext.transitionWasCancelled {
          self.presentingViewControllerDelegate?.didCancelDissmissViewController(presentedViewController, usingMode: .custom(.rightToLeft))
          self.presentedViewControllerDelegate?.didCancelDissmissViewController(usingMode: .custom(.rightToLeft))
        } else {
          self.presentingViewControllerDelegate?.didDismissViewController(presentedViewController, usingMode: .custom(.rightToLeft))
          self.presentedViewControllerDelegate?.didDismissViewController(usingMode: .custom(.rightToLeft))
        }
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
    }
  }
}
