//
//  TopKnobBottomUpPresentationController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class TopKnobBottomUpPresentationController : CustomPresentationController, DismissInteractable {
  
  // MARK: - Properties
  
  private var dismissView: UIView? = nil
  private var topKnobVisualEffectView: TopKnobVisualEffectView? = nil
  
  // MARK: - DismissInteractable
  
  var dismissInteractiveViews: [UIView] {
    var views: [UIView] = []
    if let topKnobVisualEffectView = self.topKnobVisualEffectView {
      views.append(topKnobVisualEffectView)
    }
    return views
  }
  
  // MARK: - Fullscreen
  
  override var shouldPresentInFullscreen: Bool {
    return false
  }
  
  // MARK: - UIPresentationController
  
  override func presentationTransitionWillBegin() {
    
    guard let containerView = self.containerView else {
      return
    }
    
    // Setup dismiss view
    let dismissView = UIView()
    dismissView.backgroundColor = .clear
    dismissView.frame = self.presentingViewController.view.bounds
    dismissView.isUserInteractionEnabled = true
    dismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissController)))
    self.dismissView = dismissView
    dismissView.addToContainer(containerView)
    
    // Configure the top knob view
    if self.topKnobVisualEffectView == nil, let presentedView = self.presentedView {
      
      // Crate the knob view
      let topKnobVisualEffectView = TopKnobVisualEffectView.newView()
      let knobViewRequiredOffset = TopKnobVisualEffectView.topKnobSpace + TopKnobVisualEffectView.knobHeight + TopKnobVisualEffectView.bottomKnobSpace
      topKnobVisualEffectView.addToContainer(presentedView, atIndex: 0, topMargin: -knobViewRequiredOffset)
      
      // Adjust the presented controller preferred content size
      let containerBounds = self.containerView?.bounds ?? UIScreen.main.bounds
      self.presentedViewController.preferredContentSize.height = self.presentedViewController.preferredContentSize.height > 0 ? self.presentedViewController.preferredContentSize.height + knobViewRequiredOffset : containerBounds.height
    }
    
    // Configure presentation interaction
    self.presentationInteractiveTransition = DragDownDismissInteractiveTransition(interactiveViews: self.allPresentationInteractiveViews, delegate: self)
  }
  
  override func presentationTransitionDidEnd(_ completed: Bool) {
    super.presentationTransitionDidEnd(completed)
    
    guard completed else {
      self.dismissView?.removeFromSuperview()
      self.dismissView = nil
      self.topKnobVisualEffectView?.removeFromSuperview()
      self.topKnobVisualEffectView = nil
      return
    }
    
    // Configure dismiss interaction
    self.dismissInteractiveTransition = DragDownDismissInteractiveTransition(interactiveViews: self.allDismissInteractiveViews, options: [ .contentSize(self.presentedViewController.preferredContentSize) ], delegate: self)
  }
  
  override var frameOfPresentedViewInContainerView: CGRect {
    let containerBounds = self.containerView?.bounds ?? UIScreen.main.bounds
    let height: CGFloat = self.presentedViewController.preferredContentSize.height
    let desiredYOffset = containerBounds.height - height
    let minimumYOffset: CGFloat = 100
    let adjustedYOffset: CGFloat
    let adjustedHeight: CGFloat
    if desiredYOffset < minimumYOffset {
      adjustedYOffset = minimumYOffset
      adjustedHeight = containerBounds.height - 100
    } else {
      adjustedYOffset = desiredYOffset
      adjustedHeight = height
    }
    if self.presentedViewController.preferredContentSize.height != adjustedHeight {
      let newSize = CGSize(width: self.presentedViewController.preferredContentSize.width, height: adjustedHeight)
      self.presentedViewController.preferredContentSize = newSize
    }
    return CGRect(x: 0, y: adjustedYOffset, width: containerBounds.width, height: adjustedHeight)
  }
  
  // MARK: - Actions
  
  @objc func dismissController() {
    self.presentingViewController.dismiss(animated: true, completion: nil)
  }
}

// MARK: - InteractiveTransitionDelegate

extension TopKnobBottomUpPresentationController : InteractiveTransitionDelegate {
  
  func interactionDidSurpassThreshold(_ interactiveTransition: InteractiveTransition) {
    
    // Presentation
    if interactiveTransition == self.presentationInteractiveTransition {}
    
    // Dismissal
    if interactiveTransition == self.dismissInteractiveTransition {
      self.dismissController()
    }
  }
}
