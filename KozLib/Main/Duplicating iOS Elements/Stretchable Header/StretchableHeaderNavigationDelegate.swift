//
//  StretchableHeaderNavigationDelegate.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 12/26/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

protocol StretchableHeaderNavigationDelegate : class {}
extension StretchableHeaderNavigationDelegate where Self : UIViewController {
  
  func presentStretchableHeader(presentationMode: PresentationMode) {
    let viewController = StretchableHeaderController.newViewController()    
    viewController.presentIn(self, withMode: presentationMode)
  }
}
