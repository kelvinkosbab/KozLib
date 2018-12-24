//
//  SlidingTabBarAnimator.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 12/24/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class SlidingTabBarAnimator : NSObject, UIViewControllerAnimatedTransitioning {
  
  // MARK: - Direction
  
  enum Direction {
    case rightToLeft
    case leftToRight
  }
  
  // MARK: - Init
  
  init(direction: Direction, from fromViewController: UIViewController, to toViewCongtroller: UIViewController) {
    self.direction = direction
    self.fromViewController = fromViewController
    self.toViewCongtroller = toViewCongtroller
  }
  
  // MARK: - Properties
  
  let direction: Direction
  let fromViewController: UIViewController
  let toViewCongtroller: UIViewController
  let slideDistance: CGFloat = 25
  
  // MARK: - UIViewControllerAnimatedTransitioning
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.2
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    // Initial state
    let animationDuration = self.transitionDuration(using: transitionContext)
    let targetFrame = self.fromViewController.view.frame
    self.toViewCongtroller.view.alpha = 0.0
    self.toViewCongtroller.view.frame = {
      switch self.direction {
      case .rightToLeft:
        return CGRect(x: targetFrame.origin.x + self.slideDistance, y: targetFrame.origin.y, width: targetFrame.width, height: targetFrame.height)
      case .leftToRight:
        return CGRect(x: targetFrame.origin.x - self.slideDistance, y: targetFrame.origin.y, width: targetFrame.width, height: targetFrame.height)
      }
    }()
    
    // Perform the animation
    let containerView = transitionContext.containerView
    containerView.addSubview(self.toViewCongtroller.view)
    UIView.animate(withDuration: animationDuration, animations: {
      self.toViewCongtroller.view.frame = targetFrame
      self.toViewCongtroller.view.alpha = 1
    }, completion: { _ in
      self.fromViewController.view.removeFromSuperview()
      transitionContext.completeTransition(true)
    })
  }
}
