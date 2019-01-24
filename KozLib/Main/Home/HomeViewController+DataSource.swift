//
//  HomeViewController+DataSource.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 8/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation

// MARK: - DataSourceProviderDelegate

extension HomeViewController : DataSourceProviderDelegate {
  
  func dataSourceDidUpdate() {
    self.tableView.reloadData()
  }
}

// MARK: - DataSource

extension HomeViewController {
  
  class DataSource : AutomatedDataSourceProvider {
    
    // MARK: - Properties
    
    weak var delegate: DataSourceProviderDelegate?
    
    internal var currentContent: Content?
    private lazy var _currentContent: Content = {
      
      // Build the content
      var sectionTypes: [SectionType] = []
      
      // Common iOS elements
      var generalRowTypes: [RowType] = []
      generalRowTypes.append(.pullUpController)
      generalRowTypes.append(.stretchableTableViewHeader)
      generalRowTypes.append(.appleMusicNowPlayingTransition)
      generalRowTypes.append(.badgeViewLayerAnimations)
      generalRowTypes.append(.graphingCustomLayouts)
      generalRowTypes.append(.weatherScrolling)
      sectionTypes.append(.misc(rowTypes: generalRowTypes))
      
      // Tab bar
      sectionTypes.append(.tabBarAnimations(rowTypes: [ .animatingTabBarCrossDissolve, .animatingTabBarSliding ]))
      
      // MISC
      sectionTypes.append(.misc(rowTypes: [ .permissions, .nfc, .arKit, .geofencing ]))
      
      // Network
      sectionTypes.append(.network(rowTypes: [ .basicNetwork, .networkExtension ]))
      
      // Return the content
      return Content(sectionTypes: sectionTypes)
    }()
    
    // MARK: - Content
    
    struct Content : DataSourceContent {
      let sectionTypes: [SectionType]
    }
    
    func generateContent(completion: @escaping (_ content: Content) -> Void) {
      
      DispatchQueue.global().async {
        
        // Return the content
        let content = self._currentContent
        DispatchQueue.main.async {
          completion(content)
        }
      }
    }
    
    // MARK: - SectionType
    
    enum SectionType : DataSourceSectionType {
      case misc(rowTypes: [RowType])
      case tabBarAnimations(rowTypes: [RowType])
      case network(rowTypes: [RowType])
      case iDev2018(rowTypes: [RowType])
      
      var title: String? {
        switch self {
        case .misc:
          return nil
        case .tabBarAnimations:
          return "Tab Bar Animations"
        case .network:
          return "Network"
        case .iDev2018:
          return "360iDev 2018"
        }
      }
      
      var rowTypes: [RowType] {
        switch self {
        case .misc(rowTypes: let rowTypes),
             .tabBarAnimations(rowTypes: let rowTypes),
             .network(rowTypes: let rowTypes),
             .iDev2018(rowTypes: let rowTypes):
          return rowTypes
        }
      }
    }
    
    // MARK: - RowType
    
    enum RowType : DataSourceRowType {
      case pullUpController
      case stretchableTableViewHeader
      case appleMusicNowPlayingTransition
      case badgeViewLayerAnimations
      case graphingCustomLayouts
      case weatherScrolling
      
      case permissions, nfc, arKit, geofencing
      case basicNetwork, networkExtension
      case animatingTabBarCrossDissolve, animatingTabBarSliding
      
      var title: String {
        switch self {
        case .pullUpController:
          return "Pull Up Controller (Maps, Stocks, etc)"
        case .stretchableTableViewHeader:
          return "Stretchable TableView Header"
        case .appleMusicNowPlayingTransition:
          return "Apple Music Now Playing Transition"
        case .badgeViewLayerAnimations:
          return "Badge View Layer Animations"
        case .graphingCustomLayouts:
          return "Graphs with Custom Collection View Layouts"
        case .weatherScrolling:
          return "Weather App Scrolling"
          
        case .permissions:
          return "Permissions"
        case .nfc:
          return "NFC Reader"
        case .arKit:
          return "ARKit Projects"
        case .geofencing:
          return "Geofencing"
        case .animatingTabBarCrossDissolve:
          return "Cross Dissolve Animated Tab Bar"
        case .animatingTabBarSliding:
          return "Sliding Animated Tab Bar"
          
        case .basicNetwork:
          return "Basic Network Info"
        case .networkExtension:
          return "Network Extension"
        }
      }
    }
  }
}
