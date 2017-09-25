//
//  HomeListItem.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import Foundation

enum HomeListItem {
  case nfc
  case arKit
  case transparentNavigationBar
  case expandingNavigationBar
  
  var title: String {
    switch self {
    case .nfc:
      return "NFC Reader"
    case .arKit:
      return "ARKit"
    case .transparentNavigationBar, .expandingNavigationBar:
      return "TBD"
    }
  }
  
  static let all: [HomeListItem] = [ .nfc, .arKit, .transparentNavigationBar, .expandingNavigationBar ]
}
