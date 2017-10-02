//
//  NewViewControllerProtocol.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

protocol NewViewControllerProtocol {
  static var storyboardName: String { get }
}
extension NewViewControllerProtocol where Self : UIViewController {
  
  static func newViewController() -> Self {
    return self.newViewController(fromStoryboardWithName: self.storyboardName)
  }
}
