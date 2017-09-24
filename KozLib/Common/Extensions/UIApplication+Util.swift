//
//  UIApplication+Util.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

extension UIApplication {
  
  // MARK: - Version / Build
  
  @objc var versionString: String? {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  }
  
  @objc var buildString: String? {
    return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
  }
  
  // MARK: - App dates
  
  var appDownloadDate: Date? {
    
    // To get the installation date check the creation date of the documents folder
    do {
      if let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last, let installDate = try FileManager.default.attributesOfItem(atPath: documentsUrl.path)[.creationDate] as? Date {
        return installDate
      }
    } catch {
      print("UIApplication : File error \(error.localizedDescription)")
    }
    print("UIApplication : Unable to retreive documents directory URL information")
    return nil
  }
  
  var appLastUpdateDate: Date? {
    
    // To get the date of the last update check the modification date of the bundle itself
    do {
      if let pathToInfoPlist = Bundle.main.path(forResource: "Info", ofType: "plist"), let updateDate = try FileManager.default.attributesOfItem(atPath: (pathToInfoPlist as NSString).deletingLastPathComponent)[.modificationDate] as? Date {
        return updateDate
      }
    } catch {
      print("UIApplication : File error \(error.localizedDescription)")
    }
    print("UIApplication : Unable to Info.plist URL information")
    return nil
  }
  
  // MARK: - Opening Settings
  
  func openSettingsApp(completion: (() -> Void)? = nil) {
    
    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString), self.canOpenURL(settingsUrl) else {
      return
    }
    
    self.open(settingsUrl) { (success) in
      print("UIApplication : Settings opened: \(success)")
      completion?()
    }
  }
}
