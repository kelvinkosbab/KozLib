//
//  CustomPresentationController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class CustomPresentationController : UIPresentationController {
  var presentationInteractiveTransition: InteractiveTransition?
  var dismissInteractiveTransition: InteractiveTransition?
}

extension CustomPresentationController {
  
  internal var allPresentationInteractiveViews: [UIView] {
    var interactiveViews: [UIView] = []
    // Presenting view controller
    if let presentationInteractable = self.presentingViewController.topViewController as? PresentationInteractable, presentationInteractable.presentationInteractiveViews.count > 0 {
      interactiveViews += presentationInteractable.presentationInteractiveViews
    }
    
    // Presenting controller
    if let presentationInteractable = self as? PresentationInteractable, presentationInteractable.presentationInteractiveViews.count > 0 {
      interactiveViews += presentationInteractable.presentationInteractiveViews
    }
    
    return interactiveViews
  }
  
  internal var allDismissInteractiveViews: [UIView] {
    var interactiveViews: [UIView] = []
    
    // Presented view controller
    if let dismissInteractable = self.presentedViewController.topViewController as? DismissInteractable, dismissInteractable.dismissInteractiveViews.count > 0 {
      interactiveViews += dismissInteractable.dismissInteractiveViews
    }
    
    // Presenting controller
    if let dismissInteractable = self as? DismissInteractable, dismissInteractable.dismissInteractiveViews.count > 0 {
      interactiveViews += dismissInteractable.dismissInteractiveViews
    }
    
    return interactiveViews
  }
}
