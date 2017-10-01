//
//  Network.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit
import CoreTelephony
import SystemConfiguration.CaptiveNetwork

struct Network {
  
  static var ssid: String? {
    
    guard !UIDevice.current.isSimulator else {
      return "Simulated SSID"
    }
    
    guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
      return nil
    }
    
    let flatMap: [String] = interfaceNames.flatMap { name in
      
      guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [AnyHashable : Any] else {
        return nil
      }
      
      guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
        return nil
      }
      
      return ssid
    }
    
    return flatMap.first
  }
  
  static var radioTechnology: String? {
    let networkInfo = CTTelephonyNetworkInfo()
    return networkInfo.currentRadioAccessTechnology
  }
  
  static var cellularCarrier: CTCarrier? {
    let networkInfo = CTTelephonyNetworkInfo()
    return networkInfo.subscriberCellularProvider
  }
}
