//
//  Defaults+MyManagedObjectProtocol.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import Foundation

extension Defaults : MyManagedObjectProtocol {
  
  // MARK: - MyManagedObjectProtocol
  
  static var sortDescriptors: [NSSortDescriptor] {
    return [ NSSortDescriptor(key: "isFirstLaunch", ascending: true) ]
  }
  
  // MARK; - Singleton
  
  private static var _shared: Defaults? = nil
  
  static var shared: Defaults {
    
    // Check if there is already a fetched reference
    if let shared = self._shared {
      return shared
    }
    
    // Need to fetch / create
    let shared = self.fetchAll().first ?? self.create()
    MyDataManager.shared.saveMainContext()
    return shared
  }
}
