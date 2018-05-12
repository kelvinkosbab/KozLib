//
//  TopDownPresentationController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class TopDownPresentationController : CustomPresentationController {
  
  // MARK: - Properties
  
  private var dismissView: UIView? = nil
  
  // MARK: - Fullscreen
  
  override var shouldPresentInFullscreen: Bool {
    return false
  }
  
  // MARK: - UIPresentationController
  
  override func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()
    
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
    
    // Configure presentation interaction
    self.presentationInteractiveTransition = DragUpDismissInteractiveTransition(interactiveViews: self.allPresentationInteractiveViews, delegate: self)
  }
  
  override func presentationTransitionDidEnd(_ completed: Bool) {
    super.presentationTransitionDidEnd(completed)
    
    guard completed else {
      self.dismissView?.removeFromSuperview()
      self.dismissView = nil
      return
    }
    
    // Configure dismiss interaction
    self.dismissInteractiveTransition = DragUpDismissInteractiveTransition(interactiveViews: self.allDismissInteractiveViews, options: [ .contentSize(self.presentedViewController.preferredContentSize) ], delegate: self)
  }
  
  override var frameOfPresentedViewInContainerView: CGRect {
    let containerBounds = self.containerView?.bounds ?? UIScreen.main.bounds
    let preferredHeight = self.presentedViewController.preferredContentSize.height
    return CGRect(x: 0, y: 0, width: containerBounds.width, height: preferredHeight)
  }
  
  // MARK: - Actions
  
  @objc func dismissController() {
    self.presentingViewController.dismiss(animated: true, completion: nil)
  }
}

// MARK: - InteractiveTransitionDelegate

extension TopDownPresentationController : InteractiveTransitionDelegate {
  
  func interactionDidSurpassThreshold(_ interactiveTransition: InteractiveTransition) {
    
    // Presentation
    if interactiveTransition == self.presentationInteractiveTransition {}
    
    // Dismissal
    if interactiveTransition == self.dismissInteractiveTransition {
      self.dismissController()
    }
  }
}
