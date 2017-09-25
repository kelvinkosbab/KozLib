//
//  RootViewController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class RootViewController : BaseNavigationController {
  
  // MARK: - Static Accessors
  
  static var sharedInstance: RootViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let rootViewController = appDelegate.window!.rootViewController
    return rootViewController as! RootViewController
  }
}
