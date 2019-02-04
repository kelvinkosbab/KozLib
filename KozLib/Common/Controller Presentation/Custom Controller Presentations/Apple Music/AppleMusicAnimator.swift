//
//  AppleMusicAnimator.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/2/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

class AppleMusicAnimator : NSObject, PresentableAnimator {
  
  // MARK: - PresentableAnimator
  
  weak var presentingViewControllerDelegate: PresentingViewControllerDelegate?
  weak var presentedViewControllerDelegate: PresentedViewControllerDelegate?
  
  // MARK: - Properties
  
  static let presentedTopMargin: CGFloat = 15
  static let cornerRadius: CGFloat = 10
  
  // MARK: - UIViewControllerAnimatedTransitioning
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    guard let toViewController = transitionContext.viewController(forKey: .to),
      let fromViewController = transitionContext.viewController(forKey: .from) else {
        return
    }
    
    let isPresenting = toViewController.presentedViewController != fromViewController
    _ = isPresenting ? fromViewController : toViewController
    let presentedViewController = isPresenting ? toViewController : fromViewController
    let containerView = transitionContext.containerView
    let transitionDuration = self.transitionDuration(using: transitionContext)
    
    if isPresenting {
      
      // Currently presenting
            
      // Configure the presented controller
      containerView.addSubview(presentedViewController.view)
      presentedViewController.view.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        presentedViewController.view.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: AppleMusicAnimator.presentedTopMargin),
        containerView.bottomAnchor.constraint(equalTo: presentedViewController.view.bottomAnchor, constant: 0),
        presentedViewController.view.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 0),
        containerView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: presentedViewController.view.trailingAnchor, constant: 0)
        ])
      
      // Round the top corners of the presentedBackgroundView
      presentedViewController.view.clipsToBounds = true
      presentedViewController.view.round(corners: [ .topLeft, .topRight ], radius: AppleMusicAnimator.cornerRadius)
      
      // Animate the presentation
      presentedViewController.view.frame.origin.y = containerView.bounds.height
      UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 0.83, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
        containerView.layoutIfNeeded()
      }) { _ in
        transitionContext.completeTransition(true)
      }
      
    } else {
      
      // Currently dismissing
      UIView.animate(withDuration: transitionDuration / 2, delay: 0, options: .curveEaseInOut, animations: {
        presentedViewController.view.frame.origin.y = containerView.bounds.height
      }) { _ in
        transitionContext.completeTransition(true)
      }
    }
  }
}
