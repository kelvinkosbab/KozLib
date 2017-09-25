//
//  UIDevice+Util.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

extension UIDevice {
  
  // MARK: - Device Type
  
  var isPhone: Bool {
    return self.userInterfaceIdiom == .phone
  }
  
  var isPad: Bool {
    return self.userInterfaceIdiom == .pad
  }
  
  var isTv: Bool {
    return self.userInterfaceIdiom == .tv
  }
  
  var isCarPlay: Bool {
    return self.userInterfaceIdiom == .carPlay
  }
  
  var isUnspecifiedDevice: Bool {
    return self.userInterfaceIdiom == .unspecified
  }
  
  // MARK: - Device Library
  
  var device: Device {
    return Device()
  }
  
  var isSimulator: Bool {
    return self.device.isSimulator
  }
  
  var iPhoneX: Bool {
    switch self.device {
    case .iPhoneX, .simulator(.iPhoneX):
      return true
    default:
      return false
    }
  }
  
  var modelName: String {
    return self.device.description
  }
}
