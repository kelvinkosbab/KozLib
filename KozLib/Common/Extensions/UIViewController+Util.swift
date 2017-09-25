//
//  UIViewController+Util.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

extension UIViewController {
  
  // MARK: - Adding child view controller helpers
  
  func addChildViewController(_ childViewController: UIViewController, intoContainerView containerView: UIView) {
    childViewController.view.translatesAutoresizingMaskIntoConstraints = false
    self.addChildViewController(childViewController)
    childViewController.view.frame = containerView.frame
    containerView.addSubview(childViewController.view)
    childViewController.didMove(toParentViewController: self)
    
    // Set up constraints for the embedded controller
    let top = NSLayoutConstraint(item: childViewController.view, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
    let bottom = NSLayoutConstraint(item: childViewController.view, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
    let leading = NSLayoutConstraint(item: childViewController.view, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0)
    let trailing = NSLayoutConstraint(item: childViewController.view, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0)
    containerView.addConstraints([ top, bottom, leading, trailing ])
    self.view.layoutIfNeeded()
    
    // Check if this view is a collection view, if so need to configure it for long-press reordering
    if let collectionViewController = childViewController as? UICollectionViewController {
      collectionViewController.collectionView?.configureLongPressReordering()
    }
  }
  
  // MARK: - Back Buttons
  
  func configureBackButton(title: String, style: UIBarButtonItemStyle = .plain, target: Any?, action: Selector?) {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: style, target: target, action: action)
  }
  
  func configureDefaultBackButton(target: Any? = nil, action: Selector? = nil) {
    self.configureBackButton(title: "Back", target: target, action: action)
  }
}
