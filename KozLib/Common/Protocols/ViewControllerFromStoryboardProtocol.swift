//
//  ViewControllerFromStoryboardProtocol.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

protocol ViewControllerFromStoryboardProtocol {}
extension ViewControllerFromStoryboardProtocol where Self : UIViewController {
  
  private static var className: String {
    return String(describing: self)
  }
  
  static func newViewController(fromStoryboardWithName storyboardName: String) -> Self {
    return self.newViewController(fromStoryboardWithName: storyboardName, withIdentifier: self.className)
  }
  
  static func newViewController(fromStoryboardWithName storyboardName: String, withIdentifier identifier: String) -> Self {
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
  }
}

extension UIViewController : ViewControllerFromStoryboardProtocol {}
