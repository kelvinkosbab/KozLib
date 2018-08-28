//
//  DataSourceProvider.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 8/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation

// MARK: - DataSourceProviderDelegate

protocol DataSourceProviderDelegate : class {
  func dataSourceDidUpdate()
}

// MARK: - DataSourceProvider

protocol DataSourceProvider : class {
  associatedtype Content: DataSourceContent
  var currentContent: Content? { get set }
  func generateContent(completion: @escaping (_ content: Content) -> Void)
}

extension DataSourceProvider {
  
  #if os(watchOS)
  
  // MARK: - watchOS
  
  func getItem(at rowIndex: Int) -> Self.Content.Item? {
    return self.currentContent?.getItem(at: rowIndex)
  }
  
  #else
  
  // MARK: - iOS / iOS Extension
  
  func getSectionType(section: Int) -> Self.Content.SectionType? {
    return self.currentContent?.getSectionType(section: section)
  }
  
  func getRowType(at indexPath: IndexPath) -> Self.Content.SectionType.RowType? {
    return self.currentContent?.getSectionType(section: indexPath.section)?.getRowType(at: indexPath.row)
  }
  
  var numberOfSections: Int {
    return self.currentContent?.sectionTypes.count ?? 0
  }
  
  func getNumberOfItems(section: Int) -> Int {
    return self.getSectionType(section: section)?.rowTypes.count ?? 0
  }
  
  #endif
}

// MARK: - AutomatedDataSourceProvider

protocol AutomatedDataSourceProvider : DataSourceProvider {
  var delegate: DataSourceProviderDelegate? { get set }
}

extension AutomatedDataSourceProvider {
  
  func updateContent() {
    self.generateContent { [weak self] content in
      
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.currentContent = content
      strongSelf.delegate?.dataSourceDidUpdate()
    }
  }
}
