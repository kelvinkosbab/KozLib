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
    self.toViewCongtroller.view.addToContainer(containerView)
    self.toViewCongtroller.view.isHidden = true
    
    let animateView: UIView = {
      let view = UIView()
      view.backgroundColor = self.toViewCongtroller.view.backgroundColor
      view.alpha = 0
      view.addToContainer(containerView)
      return view
    }()
    
    UIView.animate(withDuration: animationDuration / 2, delay: 0, options: [ .curveEaseInOut ], animations: {
      animateView.alpha = 1
    }) { _ in
      
      // Remove the existing tab view
      self.fromViewController.view.removeFromSuperview()
      
      // Un-hide the to view
      self.toViewCongtroller.view.isHidden = false
      
      // Animate
      UIView.animate(withDuration: animationDuration / 2, delay: 0, options: [ .curveEaseInOut ], animations: {
        animateView.alpha = 0
      }) { _ in
        animateView.removeFromSuperview()
        transitionContext.completeTransition(true)
      }
    }
  }
}
