//
//  AnimatingTabBarController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 12/23/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class AnimatingTabBarController : BaseTabBarController {
  
  // MARK: - AnimatingTabBarStyle
  
  enum AnimatingTabBarStyle {
    case slide
    case crossDissolve
  }
  
  // MARK: - Properties
  
  var tabAnimationStyle: AnimatingTabBarStyle = .crossDissolve
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.delegate = self
    
    self.configureSmallNavigationTitle()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.cancelButtonSelected))
    
    // Configure the children
    let one = HomeViewController.newViewController()
    one.tabBarItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
    
    let two = ARKitItemsViewController.newViewController()
    two.tabBarItem = UITabBarItem(title: "ARKit", image: nil, selectedImage: nil)
    
    let three = NetworkInfoTableViewController.newViewController()
    three.tabBarItem = UITabBarItem(title: "Network", image: nil, selectedImage: nil)
    
    let four = iDev2018_BadgeViewLayerAnimationsViewController.newViewController()
    four.tabBarItem = UITabBarItem(title: "Badge Layer", image: nil, selectedImage: nil)
    
    self.viewControllers = [ one, two, three, four ]
  }
  
  // MARK: - Actions
  
  @objc func cancelButtonSelected() {
    self.dismissController()
  }
}

// MARK: - UITabBarControllerDelegate

extension AnimatingTabBarController : UITabBarControllerDelegate {
  
  func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch self.tabAnimationStyle {
    case .crossDissolve:
      return CrossDissolveTabBarAnimator(from: fromVC, to: toVC)
    case .slide:
      let direction: SlidingTabBarAnimator.Direction = {
        if let fromIndex = self.viewControllers?.firstIndex(of: fromVC), let toIndex = self.viewControllers?.firstIndex(of: toVC) {
          return fromIndex < toIndex ? .rightToLeft : .leftToRight
        }
        return .rightToLeft
      }()
      return SlidingTabBarAnimator(direction: direction, from: fromVC, to: toVC)
    }
  }
}
