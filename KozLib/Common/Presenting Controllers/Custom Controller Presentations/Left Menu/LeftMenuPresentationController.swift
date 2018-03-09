//
//  LeftMenuPresentationController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class LeftMenuPresentationController : CustomPresentationController {
  
  // MARK: - Properties
  
  private var dismissView: UIView? = nil
  private var dismissVisualEffectView: UIVisualEffectView? = nil
  private let darkBlurEffect = UIBlurEffect(style: .dark)
  
  // MARK: - Fullscreen
  
  override var shouldPresentInFullscreen: Bool {
    return false
  }
  
  // MARK: - Dismiss View
  
  private func createDismissView() -> UIView {
    let blurView = UIView()
    blurView.frame = self.presentingViewController.view.bounds
    blurView.isUserInteractionEnabled = true
    blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissController)))
    
    // Set up visual effect view
    if !UIAccessibilityIsReduceTransparencyEnabled() {
      let visualEffectView = UIVisualEffectView(effect: nil)
      self.dismissVisualEffectView = visualEffectView
      visualEffectView.frame = blurView.bounds
      visualEffectView.addToContainer(blurView)
      blurView.backgroundColor = .clear
      blurView.alpha = 1
    } else {
      self.dismissVisualEffectView = nil
      blurView.backgroundColor = .black
      blurView.alpha = 0
    }
    
    return blurView
  }
  
  // MARK: - UIPresentationController
  
  override func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()
    
    guard let containerView = self.containerView else {
      return
    }
    
    // Setup dismiss view
    let dismissView = self.dismissView ?? self.createDismissView()
    self.dismissView = dismissView
    dismissView.addToContainer(containerView, atIndex: 0)
    if let visualEffectView = self.dismissVisualEffectView {
      visualEffectView.effect = nil
    } else {
      dismissView.alpha = 0
    }
    
    let presentedWidth = max(min(containerView.bounds.width - 40, 360), 280)
    self.presentedViewController.preferredContentSize.width = presentedWidth
    
    // Begin animation
    self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
      if let visualEffectView = self.dismissVisualEffectView {
        visualEffectView.effect = self.darkBlurEffect
      } else {
        dismissView.alpha = 0.75
      }
    }, completion: nil)
    
    // Configure presentation interaction
    self.presentationInteractiveTransition = DragLeftDismissInteractiveTransition(interactiveViews: self.allPresentationInteractiveViews, delegate: self)
  }
  
  override func presentationTransitionDidEnd(_ completed: Bool) {
    super.presentationTransitionDidEnd(completed)
    
    if completed {
      
      // Configure dismiss interaction
      self.dismissInteractiveTransition = DragLeftDismissInteractiveTransition(interactiveViews: self.allDismissInteractiveViews, options: [ .contentSize(self.presentedViewController.preferredContentSize) ], delegate: self)
    }
  }
  
  override func dismissalTransitionWillBegin() {
    super.dismissalTransitionWillBegin()
    
    self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
      self.dismissView?.alpha = 0
    }, completion: nil)
  }
  
  override var frameOfPresentedViewInContainerView: CGRect {
    let containerBounds = self.containerView?.bounds ?? UIScreen.main.bounds
    let width = max(min(containerBounds.width - 40, 360), 280)
    return CGRect(x: 0, y: 0, width: width, height: containerBounds.height)
  }
  
  // MARK: - Actions
  
  @objc func dismissController() {
    self.presentingViewController.dismiss(animated: true, completion: nil)
  }
}

// MARK: - InteractiveTransitionDelegate

extension LeftMenuPresentationController : InteractiveTransitionDelegate {
  
  func interactionDidSurpassThreshold(_ interactiveTransition: InteractiveTransition) {
    
    // Presentation
    if interactiveTransition == self.presentationInteractiveTransition {}
    
    // Dismissal
    if interactiveTransition == self.dismissInteractiveTransition {
      self.dismissController()
    }
  }
}
