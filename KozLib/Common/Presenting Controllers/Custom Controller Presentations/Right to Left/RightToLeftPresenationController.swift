//
//  RightToLeftPresenationController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class RightToLeftPresentationController : CustomPresentationController {
  
  // MARK: - Properties
  
  private var dismissView: UIView? = nil
  
  // MARK: - Fullscreen
  
  override var shouldPresentInFullscreen: Bool {
    return true
  }
  
  override func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()
    
    // Configure presentation interaction
    self.presentationInteractiveTransition = DragRightDismissInteractiveTransition(interactiveViews: self.allPresentationInteractiveViews, options: [ .gestureType(.screenEdgePan) ], delegate: self)
  }
  
  override func presentationTransitionDidEnd(_ completed: Bool) {
    super.presentationTransitionDidEnd(completed)
    
    guard completed else {
      self.dismissView?.removeFromSuperview()
      self.dismissView = nil
      return
    }
    
    // Configure dismiss interaction
    self.dismissInteractiveTransition = DragRightDismissInteractiveTransition(interactiveViews: self.allDismissInteractiveViews, options: [ .gestureType(.screenEdgePan) ], delegate: self)
  }
  
  // MARK: - Actions
  
  @objc func dismissController() {
    self.presentingViewController.dismiss(animated: true, completion: nil)
  }
}

// MARK: - InteractiveTransitionDelegate

extension RightToLeftPresentationController : InteractiveTransitionDelegate {
  
  func interactionDidSurpassThreshold(_ interactiveTransition: InteractiveTransition) {
    
    // Presentation
    if interactiveTransition == self.presentationInteractiveTransition {}
    
    // Dismissal
    if interactiveTransition == self.dismissInteractiveTransition {
      self.dismissController()
    }
  }
}
