//
//  PermissionManager.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation

enum PermissionAuthorizationStatus {
  case authorized, denied, notDetermined
}

protocol PermissionManagerDelegate {
  var status: PermissionAuthorizationStatus { get }
  var isAccessAuthorized: Bool { get }
  var isAccessDenied: Bool { get }
  var isAccessNotDetermined: Bool { get }
}

struct PermissionManager : PermissionManagerDelegate {
  
  // MARK: - Singleton
  
  static let shared = PermissionManager()
  
  private init() {}
  
  // MARK: - Properties
  
  let locationManager = LocationManager.shared
  let cameraManager = CameraPermissionManager.shared
  let notificationManager = NotificationManager.shared
  
  // MARK: - PermissionManagerDelegate
  
  var status: PermissionAuthorizationStatus {
    let locationStatus = self.locationManager.status
    let cameraStatus = self.cameraManager.status
    let notificationStatus = self.notificationManager.status
    
    // Check authorized status
    if locationStatus == .authorized && cameraStatus == .authorized && notificationStatus == .authorized {
      return .authorized
    }
    
    // Check not determiend status
    if locationStatus == .notDetermined || cameraStatus == .notDetermined || notificationStatus == .notDetermined {
      return .notDetermined
    }
    
    // Access is denied
    return .denied
  }
  
  var isAccessAuthorized: Bool {
    return self.locationManager.isAccessAuthorized && self.cameraManager.isAccessAuthorized && self.notificationManager.isAccessAuthorized
  }
  
  var isAccessDenied: Bool {
    return self.locationManager.isAccessDenied || self.cameraManager.isAccessDenied || self.notificationManager.isAccessDenied
  }
  
  var isAccessNotDetermined: Bool {
    return self.locationManager.isAccessNotDetermined || self.cameraManager.isAccessNotDetermined || self.notificationManager.isAccessNotDetermined
  }
}
