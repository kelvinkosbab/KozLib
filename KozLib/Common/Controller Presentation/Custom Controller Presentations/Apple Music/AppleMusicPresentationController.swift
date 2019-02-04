//
//  AppleMusicPresentationController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/2/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

class AppleMusicPresentationController : CustomPresentationController {
  
  // MARK: - Properties
  
  weak var sourceView: AppleMusicLargePlayerSourceProtocol?
  weak var destinationView: AppleMusicLargePlayerSourceProtocol?
  
  private var initialPresentingClipsToBounds: Bool = false
  private var initialPresentingCornerRadius: CGFloat = 0
  private var initialPresentedClipsToBounds: Bool = false
  private var initialPresentedCornerRadius: CGFloat = 0
  
  private lazy var backgroundDismissBlurView: UIView = {
    let view = UIView()
    view.frame = self.presentingViewController.view.bounds
    view.isUserInteractionEnabled = true
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissController)))
    view.backgroundColor = .black
    return view
  }()
  
  // MARK: - UIPresentationController
  
  override func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()
    
    guard let containerView = self.containerView,
      let transitionCoordinator = self.presentedViewController.transitionCoordinator else {
        return
    }
    
    // Setup dismiss view
    self.backgroundDismissBlurView.addToContainer(containerView, atIndex: 0)
    self.backgroundDismissBlurView.alpha = 0
    
    // Animate the transform and background alpha
    self.initialPresentingClipsToBounds = self.presentingViewController.view.clipsToBounds
    self.initialPresentingCornerRadius = self.presentingViewController.view.layer.cornerRadius
    self.presentingViewController.view.clipsToBounds = true
    transitionCoordinator.animate(alongsideTransition: { context in
      containerView.layoutIfNeeded()
      self.backgroundDismissBlurView.alpha = 0.5
      self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
      self.presentingViewController.view.layer.cornerRadius = AppleMusicAnimator.cornerRadius
    }) { _ in }
  }
  
  override func dismissalTransitionWillBegin() {
    super.dismissalTransitionWillBegin()
    
    self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
      self.backgroundDismissBlurView.alpha = 0
      self.presentingViewController.view.transform = .identity
      self.presentingViewController.view.layer.cornerRadius = self.initialPresentingCornerRadius
    }) { _ in
      self.presentingViewController.view.layer.cornerRadius = self.initialPresentingCornerRadius
      self.presentingViewController.view.clipsToBounds = self.initialPresentingClipsToBounds
    }
  }
  
  override var frameOfPresentedViewInContainerView: CGRect {
    let containerBounds = self.containerView?.bounds ?? UIScreen.main.bounds
    let topOffset = (self.containerView?.safeAreaInsets.top ?? 0) + AppleMusicAnimator.presentedTopMargin
    return CGRect(x: 0, y: topOffset, width: containerBounds.width, height: containerBounds.height - topOffset)
  }
  
  // MARK: - Actions
  
  @objc func dismissController() {
    self.presentingViewController.dismiss(animated: true, completion: nil)
  }
}

// MARK: - InteractiveTransitionDelegate

extension AppleMusicPresentationController : InteractiveTransitionDelegate {
  
  func interactionDidSurpassThreshold(_ interactiveTransition: InteractiveTransition) {
    
    // Presentation
    if interactiveTransition == self.presentationInteractiveTransition {}
    
    // Dismissal
    if interactiveTransition == self.dismissInteractiveTransition {
      self.dismissController()
    }
  }
}
