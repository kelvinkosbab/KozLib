//
//  ARState.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation

protocol ARStateDelegate : class {
  func arStateDidUpdate(_ state: ARState)
}

enum ARState {
  case configuring, normal, limited(Reason), notAvailable, unsupported(UnsupportedType)
  
  enum Reason {
    case insufficientFeatures, excessiveMotion, initializing, relocalizing
  }
  
  enum UnsupportedType {
    case ar, faceTracking, imageTracking
  }
  
  var status: String? {
    switch self {
    case .configuring:
      return "Configuring"
    case .limited(.insufficientFeatures):
      return "Insufficent Features"
    case .limited(.excessiveMotion):
      return "Excessive Motion"
    case .limited(.initializing):
      return "Initializing"
    case .limited(.relocalizing):
      return "Relocalizing"
    case .notAvailable:
      return "Not Available"
    case .unsupported(_):
      return "Unsupported Device"
    case .normal:
      return nil
    }
  }
  
  var message: String? {
    switch self {
    case .limited(.insufficientFeatures):
      return "Please move to a well lit area with defined surface features."
    case .limited(.excessiveMotion):
      return "Please hold the device steady pointing horizontally."
    case .limited(.initializing), .limited(.relocalizing):
      return "Please hold the device steady pointing horizontally in a well lit area."
    case .notAvailable, .unsupported(.ar):
      return "Only supported on Apple devices with an A9, A10, or A11 chip or newer. This includes all phones including the iPhone 6s/6s+ and newer as well as all iPad Pro models and the 2017 iPad."
    case .unsupported(.faceTracking):
      return "Face tracking requires a device with a TrueDepth front-facing camera."
    case .unsupported(.imageTracking):
      return "Image tracking requites a device running iOS 11.3 or newer."
    case .normal, .configuring:
      return nil
    }
  }
}
