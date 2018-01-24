//
//  BottomUpPresentationManager.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/24/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class BottomUpPresentationManager : NSObject, UIViewControllerTransitioningDelegate, PresenationManagerProtocol {
  
  var interactiveElement: InteractiveElement?
  
  // MARK: - PresenationManagerProtocol
  
  var presentationInteractor: InteractiveTransition? = nil
  var dismissInteractor: InteractiveTransition? = nil
  
  required override init() {
    super.init()
  }
  
  required init(presentationInteractor: InteractiveTransition, dismissInteractor: InteractiveTransition) {
    self.presentationInteractor = presentationInteractor
    self.dismissInteractor = dismissInteractor
    super.init()
  }
  
  required init(presentationInteractor: InteractiveTransition) {
    self.presentationInteractor = presentationInteractor
    super.init()
  }
  
  required init(dismissInteractor: InteractiveTransition) {
    self.dismissInteractor = dismissInteractor
    super.init()
  }
  
  convenience init(interactiveElement: InteractiveElement?, dismissInteractor: InteractiveTransition) {
    self.init(dismissInteractor: dismissInteractor)
    self.interactiveElement = interactiveElement
  }
  
  // MARK: - UIViewControllerTransitioningDelegate
  
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let controller = BottomUpPresentationController(presentedViewController: presented, presenting: source)
    controller.interactiveElement = self.interactiveElement
    return controller
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return BottomUpAnimator(interactiveElement: self.interactiveElement)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return BottomUpAnimator(interactiveElement: self.interactiveElement)
  }
  
  func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    if let presentationInteractor = self.presentationInteractor {
      return presentationInteractor.hasStarted ? presentationInteractor : nil
    }
    return nil
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    if let dismissInteractor = self.dismissInteractor {
      return dismissInteractor.hasStarted ? dismissInteractor : nil
    }
    return nil
  }
  
  // MARK: - Animator
  
  class BottomUpAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    let interactiveElement: InteractiveElement?
    
    init(interactiveElement: InteractiveElement?) {
      self.interactiveElement = interactiveElement
      super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      
      guard let toViewController = transitionContext.viewController(forKey: .to), let fromViewController = transitionContext.viewController(forKey: .from) else {
        return
      }
      
      let isUnwinding = toViewController.presentedViewController == fromViewController
      let isPresenting = !isUnwinding
      
      let presentingViewController = isPresenting ? fromViewController : toViewController
      let presentedViewController = isPresenting ? toViewController : fromViewController
      let containerView = transitionContext.containerView
      
      let presentedYOffset: CGFloat
      if let interactiveElement = self.interactiveElement {
        presentedYOffset = (interactiveElement.size ?? 0) + (interactiveElement.offset ?? 0)
      } else {
        presentedYOffset = containerView.bounds.height
      }
      
      if isPresenting {
        
        // Currently presenting
        presentedViewController.view.frame.origin.y = containerView.bounds.height
        containerView.addSubview(presentedViewController.view)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
          presentingViewController.setNeedsStatusBarAppearanceUpdate()
          presentedViewController.setNeedsStatusBarAppearanceUpdate()
          presentedViewController.view.frame.origin.y -= presentedYOffset
        }, completion: { (_) in
          transitionContext.completeTransition(true)
        })
        
      } else {
        
        // Currently dismissing
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
          presentingViewController.setNeedsStatusBarAppearanceUpdate()
          presentedViewController.setNeedsStatusBarAppearanceUpdate()
          presentedViewController.view.frame.origin.y += presentedYOffset
        }, completion: { (_) in
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
      }
    }
  }
  
  // MARK: - Presentation Controller
  
  class BottomUpPresentationController : UIPresentationController {
    
    var interactiveElement: InteractiveElement?
    
    // MARK: - Properties
    
    private var dismissView: UIView? = nil
    
    override var shouldPresentInFullscreen: Bool {
      return false
    }
    
    // MARK: - Blur View
    
    private func createDismissView() -> UIView {
      let view = UIView()
      view.backgroundColor = .clear
      view.frame = self.presentingViewController.view.bounds
      view.isUserInteractionEnabled = true
      view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissController)))
      return view
    }
    
    // MARK: - UIPresentationController
    
    override func presentationTransitionWillBegin() {
      
      guard let containerView = self.containerView else {
        return
      }
      
      // Setup blur view
      let dismissView = self.dismissView ?? self.createDismissView()
      self.dismissView = dismissView
      dismissView.addToContainer(containerView, atIndex: 0)
    }
    
    override func dismissalTransitionWillBegin() {
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
      }, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
      super.containerViewWillLayoutSubviews()
      
      self.presentedView?.frame = self.frameOfPresentedViewInContainerView
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
      if let size = self.containerView?.bounds.size {
        let height: CGFloat = self.interactiveElement?.size ?? size.height
        let yOffset: CGFloat = self.interactiveElement?.offset ?? 0
        return CGRect(x: 0, y: size.height - yOffset - height, width: size.width, height: height)
      }
      return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    // MARK: - Actions
    
    @objc func dismissController() {
      self.presentedViewController.dismiss(animated: true, completion: nil)
    }
  }
}
