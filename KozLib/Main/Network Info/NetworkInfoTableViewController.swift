//
//  NetworkInfoTableViewController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class NetworkInfoTableViewController : BaseTableViewController {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> NetworkInfoTableViewController {
    return self.newViewController(fromStoryboardWithName: "Network")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Network Info"
    self.navigationItem.largeTitleDisplayMode = .always
    
    self.configureDefaultBackButton()
  }
}
