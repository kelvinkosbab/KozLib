//
//  HomeViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class HomeViewController : BaseTableViewController, ARKitNavigationDelegate, NFCNavigationDelegate, NetworkNavigationDelegate, PermissionsNavigationDelegate, GeofencingNavigationDelegate, iDev2018NavigationDelegate {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> HomeViewController {
    return self.newViewController(fromStoryboardWithName: "Main")
  }
  
  // MARK: - DataSource
  
  internal lazy var dataSource: DataSource = {
    let dataSource = DataSource()
    dataSource.delegate = self
    return dataSource
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "KozLibrary"
    self.navigationItem.largeTitleDisplayMode = .always
    
    self.configureDefaultBackButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.dataSource.updateContent()
  }
  
  // MARK: - Actions
  
  func didSelect(rowType: DataSource.RowType) {
    switch rowType {
      
    // MISC
    case .permissions:
      self.transitionToPermissions()
    case .arKit:
      self.transitionToARKitItems(presentationMode: .navStack)
    case .geofencing:
      self.transitionToGeotification(presentationMode: .navStack)
    case .nfc:
      self.transitionToNFC(presentationMode: .navStack)
      
    case .weatherScrolling:
      let viewController = WeatherController()
      viewController.presentIn(self, withMode: .modal(.formSheet, .coverVertical))
      
    case .pullUpController: break
      
    // Network
    case .basicNetwork:
      self.transitionToNetworkInfo(presentationMode: .navStack)
    case .networkExtension:
      self.transitionToNetworkExtension(presentationMode: .navStack)
      
    // 360iDev 2018
    case .badgeViewLayerAnimations:
      self.iDev_presentBadgeViewAnimations()
    case .graphingCustomLayouts:
      self.iDev_presentCustomLayoutGraphing()
    }
  }
}
