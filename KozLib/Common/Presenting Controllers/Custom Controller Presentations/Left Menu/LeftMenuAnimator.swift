//
//  LeftMenuAnimator.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class LeftMenuAnimator : NSObject, PresentableAnimator {
  
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
    
    // Calculate preferred width
    let presentedWidth = max(min(containerView.bounds.width - 40, 360), 280)
    
    if isPresenting {
      
      // Add the presented view
      containerView.addSubview(presentedViewController.view)
      
      // Apply constraints
      let width = NSLayoutConstraint(item: presentedViewController.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: presentedWidth)
      presentedViewController.view.translatesAutoresizingMaskIntoConstraints = false
      presentedViewController.view.addConstraint(width)
      
      let top = NSLayoutConstraint(item: presentedViewController.view, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
      let bottom = NSLayoutConstraint(item: presentedViewController.view, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
      containerView.addConstraints([ top, bottom ])
      
      // Currently presenting
      self.presentingViewControllerDelegate?.willPresentViewController(presentedViewController)
      self.presentedViewControllerDelegate?.willPresentViewController()
      presentedViewController.view.frame.origin.x = -presentedWidth
      UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
        presentedViewController.view.layoutIfNeeded()
        presentedViewController.view.frame.origin.x += presentedWidth
        self.presentingViewControllerDelegate?.isPresentingViewController(presentedViewController)
        self.presentedViewControllerDelegate?.isPresentingViewController()
      }, completion: { _ in
        self.presentingViewControllerDelegate?.didPresentViewController(presentedViewController)
        self.presentedViewControllerDelegate?.didPresentViewController()
        transitionContext.completeTransition(true)
      })
      
    } else {
      
      // Currently dismissing
      self.presentingViewControllerDelegate?.willDismissViewController(presentedViewController)
      self.presentedViewControllerDelegate?.willDismissViewController()
      UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
        presentedViewController.view.frame.origin.x -= presentedWidth
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
