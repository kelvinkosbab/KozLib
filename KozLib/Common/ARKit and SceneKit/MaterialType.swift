//
//  MaterialType.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import Foundation

enum MaterialType: String {
  case tron, oakfloor2, sculptedfloorboards, granitesmooth, transparent
  
  var nextCubeMaterial: MaterialType {
    switch self {
    case .oakfloor2:
      return .sculptedfloorboards
    case .sculptedfloorboards:
      return .granitesmooth
    case .granitesmooth:
      return .oakfloor2
      
    case .tron, .transparent:
      return .tron
    }
  }
  
  var nextPlaneMaterial: MaterialType {
    switch self {
    case .tron:
      return .oakfloor2
    case .oakfloor2:
      return .sculptedfloorboards
    case .sculptedfloorboards:
      return .granitesmooth
    case .granitesmooth:
      return .transparent
    case .transparent:
      return .tron
    }
  }
}
