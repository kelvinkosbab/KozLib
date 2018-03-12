//
//  NetworkInfoNavigationDelegate.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

protocol NetworkNavigationDelegate : class {}
extension NetworkNavigationDelegate where Self : UIViewController {
  
  func transitionToNetworkInfo(presentationMode: PresentationMode) {
    let viewController = NetworkInfoTableViewController.newViewController()
    viewController.presentIn(self, withMode: presentationMode)
  }
  
  func transitionToNetworkExtension(presentationMode: PresentationMode) {
    let viewController = NetworkExtensionViewController.newViewController()
    viewController.presentIn(self, withMode: presentationMode)
  }
  
  func openWiFiSettings() {
    let urlCheck1 = URL(string: "App-Prefs:root=WIFI")
    let urlCheck2 = URL(string: "prefs:root=WIFI")
    let urlCheck3 = URL(string: UIApplicationOpenSettingsURLString)
    if let url = urlCheck1, UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else if let url = urlCheck2, UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else if let url = urlCheck3, UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      Log.log("Unable to open WiFi Setting!");
    }
  }
}
