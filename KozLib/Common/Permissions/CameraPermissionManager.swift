//
//  CameraPermissionManager.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation
import AVFoundation

protocol CameraPermissionDelegate : class {
  func cameraPermissionManagerDidUpdateAuthorization(isAuthorized: Bool)
}

class CameraPermissionManager : NSObject, PermissionManagerDelegate {
  
  // MARK: - Singleton
  
  static let shared = CameraPermissionManager()
  
  private override init() { super.init() }
  
  // MARK: - Properties
  
  weak var authorizationDelegate: CameraPermissionDelegate? = nil
  
  // MARK: - PermissionManagerDelegate
  
  var status: PermissionAuthorizationStatus {
    switch self.avAuthorizationStatus {
    case .authorized:
      return .authorized
    case .denied, .restricted:
      return .denied
    case .notDetermined:
      return .notDetermined
    }
  }
  
  private var avAuthorizationStatus: AVAuthorizationStatus {
    return AVCaptureDevice.authorizationStatus(for: .video)
  }
  
  var isAccessAuthorized: Bool {
    return self.avAuthorizationStatus == .authorized
  }
  
  var isAccessDenied: Bool {
    switch self.avAuthorizationStatus {
    case .denied, .restricted:
      return true
    default:
      return false
    }
  }
  
  var isAccessNotDetermined: Bool {
    return self.avAuthorizationStatus == .notDetermined
  }
  
  // MARK: - Authorization
  
  func requestAuthorization() {
    AVCaptureDevice.requestAccess(for: .video) { isAuthorized in
      
      if isAuthorized {
        Log.log("Authorization authorized")
      } else {
        Log.log("Authorization declined")
      }
      
      // Notify delegate
      DispatchQueue.main.async { [weak self] in
        self?.authorizationDelegate?.cameraPermissionManagerDidUpdateAuthorization(isAuthorized: isAuthorized)
      }
    }
  }
}
