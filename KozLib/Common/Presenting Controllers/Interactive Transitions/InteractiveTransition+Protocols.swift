//
//  InteractiveTransition+Protocols.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/26/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

// MARK: - PresentationInteractable

protocol PresentationInteractable : class {
  var presentationInteractiveViews: [UIView] { get }
}

// MARK: - DismissInteractable

protocol DismissInteractable : class {
  var dismissInteractiveViews: [UIView] { get }
}

// MARK: - InteractiveTransitionDelegate

protocol InteractiveTransitionDelegate : class {
  func interactionDidSurpassThreshold(_ interactiveTransition: InteractiveTransition)
}
