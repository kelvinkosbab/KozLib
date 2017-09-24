//
//  HomeViewController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class HomeViewController : UITableViewController {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> HomeViewController {
    return self.newStoryboardController(fromStoryboardWithName: "Main", withIdentifier: "HomeViewController") as! HomeViewController
  }
}

class HomeTableListCell : UITableViewCell {
  
}

enum HomeListItem {
  case nfc
  case arKit
  
  var title: String {
    switch self {
    case .nfc:
      return "NFC Reader"
    case .arKit:
      return "ARKit"
    }
  }
}
