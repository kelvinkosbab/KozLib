//
//  TopDownAnimator.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class TopDownAnimator : NSObject, PresentableAnimator {
  
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
    
    // Calculate preferred height
    let presentedYOffset: CGFloat = presentedViewController.preferredContentSize.height > 0 ? presentedViewController.preferredContentSize.height : containerView.bounds.height
    
    if isPresenting {
      
      // Currently presenting
      self.presentingViewControllerDelegate?.willPresentViewController(presentedViewController, usingMode: .custom(.topDown))
      self.presentedViewControllerDelegate?.willPresentViewController(usingMode: .custom(.topDown))
      presentedViewController.view.frame.origin.y -= presentedYOffset
      containerView.addSubview(presentedViewController.view)
      UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
        presentedViewController.view.frame.origin.y += presentedYOffset
        self.presentingViewControllerDelegate?.isPresentingViewController(presentedViewController, usingMode: .custom(.topDown))
        self.presentedViewControllerDelegate?.isPresentingViewController(usingMode: .custom(.topDown))
      }, completion: { _ in
        self.presentingViewControllerDelegate?.didPresentViewController(presentedViewController, usingMode: .custom(.topDown))
        self.presentedViewControllerDelegate?.didPresentViewController(usingMode: .custom(.topDown))
        transitionContext.completeTransition(true)
      })
      
    } else {
      
      // Currently dismissing
      self.presentingViewControllerDelegate?.willDismissViewController(presentedViewController, usingMode: .custom(.topDown))
      self.presentedViewControllerDelegate?.willDismissViewController(usingMode: .custom(.topDown))
      UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
        presentedViewController.view.frame.origin.y -= presentedYOffset
        self.presentingViewControllerDelegate?.isDismissingViewController(presentedViewController, usingMode: .custom(.topDown))
        self.presentedViewControllerDelegate?.isDismissingViewController(usingMode: .custom(.topDown))
      }, completion: { _ in
        if transitionContext.transitionWasCancelled {
          self.presentingViewControllerDelegate?.didCancelDissmissViewController(presentedViewController, usingMode: .custom(.topDown))
          self.presentedViewControllerDelegate?.didCancelDissmissViewController(usingMode: .custom(.topDown))
        } else {
          self.presentingViewControllerDelegate?.didDismissViewController(presentedViewController, usingMode: .custom(.topDown))
          self.presentedViewControllerDelegate?.didDismissViewController(usingMode: .custom(.topDown))
        }
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })
    }
  }
}
