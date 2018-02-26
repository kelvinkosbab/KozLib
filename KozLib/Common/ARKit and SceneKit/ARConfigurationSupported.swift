//
//  ARConfigurationSupported.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import ARKit

struct ARSupported {
  
  static var isFaceTrackingSupported: Bool {
    return ARFaceTrackingConfiguration.isSupported
  }
  
  static var isImageTrackingSupported: Bool {
    if #available(iOS 11.3, *) {
      return true
    } else {
      return false
    }
  }
}
