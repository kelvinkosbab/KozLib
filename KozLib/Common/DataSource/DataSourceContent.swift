//
//  DataSourceContent.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 8/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

#if os(watchOS)

// MARK: - watchOS

protocol DataSourceContent {
  associatedtype Item: DataSourceItem
  var items: [Item] { get }
  init(items: [Item])
}

extension DataSourceContent {
  
  func getItem(at rowIndex: Int) -> Item? {
    if rowIndex < self.items.count {
      let item = self.items[rowIndex]
      return item
    }
    return nil
  }
}

protocol DataSourceItem {}

#else

// MARK: - iOS / iOS Extension

protocol DataSourceContent {
  associatedtype SectionType: DataSourceSectionType
  var sectionTypes: [SectionType] { get }
  init(sectionTypes: [SectionType])
}

extension DataSourceContent {
  
  func getSectionType(section: Int) -> SectionType? {
    if section < self.sectionTypes.count {
      let sectionType = self.sectionTypes[section]
      return sectionType
    }
    return nil
  }
}

protocol DataSourceSectionType {
  associatedtype RowType: DataSourceRowType
  var rowTypes: [RowType] { get }
}

extension DataSourceSectionType {
  
  func getRowType(at row: Int) -> RowType? {
    if row < self.rowTypes.count {
      let rowType = self.rowTypes[row]
      return rowType
    }
    return nil
  }
}

protocol DataSourceRowType {}

#endif
