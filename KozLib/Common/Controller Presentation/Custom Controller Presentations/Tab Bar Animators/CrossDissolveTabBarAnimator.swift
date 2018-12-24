//
//  CrossDissolveTabBarAnimator.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 12/24/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class CrossDissolveTabBarAnimator : NSObject, UIViewControllerAnimatedTransitioning {
  
  // MARK: - Init
  
  init(from fromViewController: UIViewController, to toViewCongtroller: UIViewController) {
    self.fromViewController = fromViewController
    self.toViewCongtroller = toViewCongtroller
  }
  
  // MARK: - Properties
  
  let fromViewController: UIViewController
  let toViewCongtroller: UIViewController
  
  // MARK: - UIViewControllerAnimatedTransitioning
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    // Perform the animation
    let animationDuration = self.transitionDuration(using: transitionContext)
    let containerView = transitionContext.containerView
    self.toViewCongtroller.view.alpha = 0
    self.toViewCongtroller.view.frame = self.fromViewController.view.frame
    containerView.addSubview(self.toViewCongtroller.view)
    UIView.animate(withDuration: animationDuration, delay: 0, options: [ .curveEaseInOut ], animations: {
      self.toViewCongtroller.view.alpha = 1
    }) { _ in
      self.fromViewController.view.removeFromSuperview()
      transitionContext.completeTransition(true)
    }
  }
}
