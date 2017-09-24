//
//  UIDevice+Util.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

extension UIDevice {
  
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
