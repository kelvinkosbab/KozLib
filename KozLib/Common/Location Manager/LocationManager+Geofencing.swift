//
//  LocationManager+Geofencing.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 3/12/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit
import CoreLocation

extension LocationManager {
  
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    if region is CLCircularRegion {
      self.handleEvent(forRegion: region)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    if region is CLCircularRegion {
      self.handleEvent(forRegion: region)
    }
  }
  
  internal func handleEvent(forRegion region: CLRegion) {
    
    // Show an alert if application is active
    if UIApplication.shared.applicationState == .active {
      guard let message = self.note(fromRegionIdentifier: region.identifier) else { return }
      UIApplication.shared.keyWindow?.rootViewController?.showAlert(withTitle: "Geofencing", message: message)
    } else {
      // Otherwise present a local notification
      guard let message = self.note(fromRegionIdentifier: region.identifier) else { return }
      NotificationManager.shared.scheduleLocalNotification(title: "Geofencing", body: message, triggerDate: Date().addingTimeInterval(2))
    }
  }
  
  func note(fromRegionIdentifier identifier: String) -> String? {
    let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) as? [NSData]
    let geotifications = savedItems?.map { NSKeyedUnarchiver.unarchiveObject(with: $0 as Data) as? Geotification }
    let index = geotifications?.firstIndex { $0?.identifier == identifier }
    return index != nil ? geotifications?[index!]?.note : nil
  }
}
