//
//  MyDataManager.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 9/23/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import Foundation
import CoreData

class MyDataManager: NSObject, DataMangerProtocol {
  
  // MARK: - Singleton
  
  static let shared = MyDataManager()
  
  // MARK: - Init
  
  private override init() {
    super.init()
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.contextWillSave(_:)), name: .NSManagedObjectContextWillSave, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.contextDidSave(_:)), name: .NSManagedObjectContextDidSave, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.contextObjectsDidChange(_:)), name: .NSManagedObjectContextObjectsDidChange, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - DataMangerProtocol
  
  internal let persistentContainerName = "MyCoreNFC"
  
  internal lazy var persistentContainer: NSPersistentContainer = {
    return self.getPersistentContainer()
  }()
  
  // MARK: - Context Notifications
  
  @objc private func contextWillSave(_ notification: Notification) {}
  
  @objc private func contextDidSave(_ notification: Notification) {
    if let _ = notification.object as? NSManagedObjectContext {}
  }
  
  @objc private func contextObjectsDidChange(_ notification: Notification) {}
}
