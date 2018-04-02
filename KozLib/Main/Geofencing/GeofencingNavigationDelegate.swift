//
//  GeofencingNavigationDelegate.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 3/12/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

protocol GeofencingNavigationDelegate : class {}
extension GeofencingNavigationDelegate where Self : UIViewController {
  
  func transitionToGeotification(presentationMode: PresentationMode) {
    let viewController = GeotificationsViewController.newViewController()
    viewController.presentIn(self, withMode: presentationMode)
  }
}
