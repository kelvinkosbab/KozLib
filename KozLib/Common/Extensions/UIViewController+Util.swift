//
//  UIViewController+Util.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

extension UIViewController {
  
  // MARK: - Accessing controllers from storyboard
  
  static func newStoryboardController(fromStoryboardWithName storyboard: String, withIdentifier identifier: String) -> UIViewController {
    let storyboard = UIStoryboard(name: storyboard, bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: identifier)
  }
  
  // MARK: - Adding child view controller helpers
  
  func addChildViewController(_ childViewController: UIViewController, intoView: UIView) {
    self.addChildViewController(childViewController)
    childViewController.view.addToContainer(intoView)
    childViewController.didMove(toParentViewController: self)
    
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
