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
      
      // MISC
      sectionTypes.append(.misc(rowTypes: [ .permissions, .nfc, .arKit, .geofencing, .animatingTabBarSelections ]))
      
      // Common iOS elements
      sectionTypes.append(.commonIosElements(rowTypes: [ .weatherScrolling, .pullUpController, .stretchableTableViewHeadser ]))
      
      // 2018 360iDev
      sectionTypes.append(.iDev2018(rowTypes: [ .badgeViewLayerAnimations, .graphingCustomLayouts ]))
      
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
      case commonIosElements(rowTypes: [RowType])
      case misc(rowTypes: [RowType])
      case network(rowTypes: [RowType])
      case iDev2018(rowTypes: [RowType])
      
      var title: String? {
        switch self {
        case .commonIosElements:
          return "Common iOS Elements"
        case .misc:
          return nil
        case .network:
          return "Network"
        case .iDev2018:
          return "360iDev 2018"
        }
      }
      
      var rowTypes: [RowType] {
        switch self {
        case .commonIosElements(rowTypes: let rowTypes), .misc(rowTypes: let rowTypes), .network(rowTypes: let rowTypes), .iDev2018(rowTypes: let rowTypes):
          return rowTypes
        }
      }
    }
    
    // MARK: - RowType
    
    enum RowType : DataSourceRowType {
      case permissions, nfc, arKit, geofencing
      case weatherScrolling, pullUpController
      case basicNetwork, networkExtension
      case badgeViewLayerAnimations, graphingCustomLayouts, stretchableTableViewHeadser
      case animatingTabBarSelections
      
      var title: String {
        switch self {
        case .permissions:
          return "Permissions"
        case .nfc:
          return "NFC Reader"
        case .arKit:
          return "ARKit Projects"
        case .geofencing:
          return "Geofencing"
        case .animatingTabBarSelections:
          return "Animating Tab Bar Selections"
          
        case .weatherScrolling:
          return "Weather App Scrolling"
        case .pullUpController:
          return "Pull Up Controller (Maps, Stocks, etc)"
        case .stretchableTableViewHeadser:
          return "Stretchable TableView Header"
          
        case .basicNetwork:
          return "Basic Network Info"
        case .networkExtension:
          return "Network Extension"
          
        case .badgeViewLayerAnimations:
          return "Badge View Layer Animations"
        case .graphingCustomLayouts:
          return "Graphs with Custom Collection View Layouts"
        }
      }
    }
  }
}
