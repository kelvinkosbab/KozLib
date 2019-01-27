//
//  HomeViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class HomeViewController : BaseTableViewController, ARKitNavigationDelegate, NFCNavigationDelegate, NetworkNavigationDelegate, PermissionsNavigationDelegate, GeofencingNavigationDelegate, iDev2018NavigationDelegate, StretchableHeaderNavigationDelegate {
  
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
      
    // General
      
    case .pullUpController:
      let viewController = BottomSheetContainerViewController.newViewController()
      viewController.presentIn(self, withMode: .modal(.formSheet, .coverVertical))
      
    case .stretchableTableViewHeader:
      self.presentStretchableHeader(presentationMode: .modal(.formSheet, .coverVertical))
      
    case .appleMusicNowPlayingTransition:
      let viewController = AppleMusicNowPlayingContainerViewController.newViewController()
      viewController.presentIn(self, withMode: .navStack)
      
    case .badgeViewLayerAnimations:
      self.iDev_presentBadgeViewAnimations()
      
    case .graphingCustomLayouts:
      self.iDev_presentCustomLayoutGraphing()
      
    case .weatherScrolling:
      let viewController = WeatherController()
      viewController.presentIn(self, withMode: .modal(.formSheet, .coverVertical))
      
    // Tab bar animations
      
    case .animatingTabBarCrossDissolve:
      let viewController: AnimatingTabBarController = {
        let viewController = AnimatingTabBarController()
        viewController.tabAnimationStyle = .crossDissolve
        return viewController
      }()
      viewController.presentIn(self, withMode: .modal(.fullScreen, .coverVertical))
      
    case .animatingTabBarSliding:
      let viewController: AnimatingTabBarController = {
        let viewController = AnimatingTabBarController()
        viewController.tabAnimationStyle = .slide
        return viewController
      }()
      viewController.presentIn(self, withMode: .modal(.fullScreen, .coverVertical))
      
    // MISC
      
    case .permissions:
      self.transitionToPermissions()
    case .arKit:
      self.transitionToARKitItems(presentationMode: .navStack)
    case .geofencing:
      self.transitionToGeotification(presentationMode: .navStack)
    case .nfc:
      self.transitionToNFC(presentationMode: .navStack)
      
    // Network
      
    case .basicNetwork:
      self.transitionToNetworkInfo(presentationMode: .navStack)
    case .networkExtension:
      self.transitionToNetworkExtension(presentationMode: .navStack)
    }
  }
}
