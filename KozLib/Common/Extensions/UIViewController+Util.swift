//
//  UIViewController+Util.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

extension UIViewController {
  
  // MARK: - Add Child View Controller
  
  func add(childViewController: UIViewController, intoContainerView containerView: UIView, relativeLayoutType: UIView.RelativeLayoutType = .view) {
    childViewController.view.translatesAutoresizingMaskIntoConstraints = false
    self.addChildViewController(childViewController)
    childViewController.view.frame = containerView.frame
    childViewController.view.addToContainer(containerView, relativeLayoutType: relativeLayoutType)
    childViewController.didMove(toParentViewController: self)
    
    // Check if this view is a collection view, if so need to configure it for long-press reordering
    if let collectionViewController = childViewController as? UICollectionViewController {
      collectionViewController.collectionView?.configureLongPressReordering()
    }
  }
  
  // MARK: - Remove Child View Controller
  
  func remove(childViewController: UIViewController) {
    childViewController.willMove(toParentViewController: nil)
    childViewController.view.removeFromSuperview()
    childViewController.removeFromParentViewController()
  }
  
  // MARK: - Back Buttons
  
  func configureBackButton(title: String, style: UIBarButtonItemStyle = .plain, target: Any?, action: Selector?) {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: style, target: target, action: action)
  }
  
  func configureDefaultBackButton(target: Any? = nil, action: Selector? = nil) {
    self.configureBackButton(title: "Back", target: target, action: action)
  }
}
