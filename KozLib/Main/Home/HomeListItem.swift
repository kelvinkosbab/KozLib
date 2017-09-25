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
  case arKitPlaneMapping
  case transparentNavigationBar
  case expandingNavigationBar
  
  var title: String {
    switch self {
    case .arKitPlaneMapping:
      return "ARKit Plane Mapping"
    case .nfc:
      return "NFC Reader"
    case .transparentNavigationBar, .expandingNavigationBar:
      return "TBD"
    }
  }
  
  static let all: [HomeListItem] = [ .arKitPlaneMapping, .nfc, .transparentNavigationBar, .expandingNavigationBar ]
}
