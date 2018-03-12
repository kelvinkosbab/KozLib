//
//  LocationManager.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation
import CoreLocation

/*
 * Handles retrieving the location and heading from CoreLocation
 */

extension Notification.Name {
  static let locationManagerDidUpdateCurrentLocation = Notification.Name("locationManagerDidUpdateCurrentLocation")
  static let locationManagerDidUpdateCurrentHeading = Notification.Name("locationManagerDidUpdateCurrentHeading")
  static let locationManagerdidUpdateAuthorization = Notification.Name("locationManagerdidUpdateAuthorization")
}

extension CLHeading {
  
  var heading: CLLocationDirection {
    if self.headingAccuracy >= 0 {
      return self.trueHeading
    } else {
      return self.magneticHeading
    }
  }
}

protocol LocationManagerDelegate : class {
  func locationManagerDidUpdateCurrentLocation(_ locationManager: LocationManager, currentLocation: CLLocation?)
  func locationManagerDidUpdateCurrentHeading(_ locationManager: LocationManager, currentHeading: CLHeading?)
}

protocol LocationManagerAuthorizationDelegate : class {
  func locationManagerDidUpdateAuthorization()
}

class LocationManager : NSObject, CLLocationManagerDelegate, PermissionManagerDelegate {
  
  // MARK: - Singleton
  
  static let shared = LocationManager()
  
  private override init() {
    
    let locationManager = CLLocationManager()
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.headingFilter = kCLHeadingFilterNone
    locationManager.pausesLocationUpdatesAutomatically = false
    locationManager.startUpdatingHeading()
    locationManager.startUpdatingLocation()
    self.locationManager = locationManager
    
    super.init()
    
    self.locationManager.delegate = self
    self.currentLocation = self.locationManager.location
    self.currentHeading = self.locationManager.heading
  }
  
  // MARK: - PermissionManagerDelegate
  
  var status: PermissionAuthorizationStatus {
    switch self.clAuthorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      return .authorized
    case .denied, .restricted:
      return .denied
    case .notDetermined:
      return .notDetermined
    }
  }
  
  // MARK: - Properties / Init
  
  weak var delegate: LocationManagerDelegate? = nil
  weak var authorizationDelegate: LocationManagerAuthorizationDelegate? = nil
  
  internal let locationManager: CLLocationManager
  
  var currentLocation: CLLocation? {
    didSet {
      if let currentLocation = self.currentLocation {
        self.delegate?.locationManagerDidUpdateCurrentLocation(self, currentLocation: currentLocation)
        NotificationCenter.default.post(name: .locationManagerDidUpdateCurrentLocation, object: currentLocation)
      }
    }
  }
  
  var currentHeading: CLHeading? {
    didSet {
      if let currentHeading = self.currentHeading {
        self.delegate?.locationManagerDidUpdateCurrentHeading(self, currentHeading: currentHeading)
        NotificationCenter.default.post(name: .locationManagerDidUpdateCurrentHeading, object: currentHeading)
      }
    }
  }
  
  // MARK: - Permissions
  
  private var clAuthorizationStatus: CLAuthorizationStatus {
    return CLLocationManager.authorizationStatus()
  }
  
  var isAccessAuthorized: Bool {
    switch self.clAuthorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      return true
    case .denied, .restricted, .notDetermined:
      return false
    }
  }
  
  var isAccessDenied: Bool {
    switch self.clAuthorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
      return false
    case .denied, .restricted:
      return true
    }
  }
  
  var isAccessNotDetermined: Bool {
    return self.clAuthorizationStatus == .notDetermined
  }
  
  // MARK: - Authorization
  
  func requestAuthorization() {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedAlways, .authorizedWhenInUse:
      return
    case .denied, .restricted:
      return
    case .notDetermined:
      self.locationManager.requestAlwaysAuthorization()
    }
  }
  
  // MARK: - CLLocationManagerDelegate
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    self.authorizationDelegate?.locationManagerDidUpdateAuthorization()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    self.currentLocation = locations.last ?? manager.location
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    self.currentHeading = newHeading
  }
  
  func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
    return true
  }
}
