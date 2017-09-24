//
//  MyManagedObject.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/23/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import Foundation
import CoreData

protocol MyManagedObject {
  static var sortDescriptors: [NSSortDescriptor] { get }
}

extension MyManagedObject where Self : NSManagedObject {
  
  private static var entityName: String {
    return String(describing: Self.self)
  }
  
  // MARK: - Managed Object Context
  
  static var mainContext: NSManagedObjectContext {
    return MyDataManager.shared.mainContext
  }
  
  static func saveMainContext() {
    MyDataManager.shared.saveMainContext()
  }
  
  // MARK: - Create
  
  static func create() -> Self {
    return NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: self.mainContext) as! Self
  }
  
  // MARK: - Managed Object Entity
  
  private static func getEntity() -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: self.entityName, in: self.mainContext)
  }
  
  // MARK: - Fetching
  
  static func newGenericFetchRequest() -> NSFetchRequest<NSFetchRequestResult>? {
    return NSFetchRequest<Self>(entityName: self.entityName) as? NSFetchRequest<NSFetchRequestResult>
  }
  
  static func newFetchRequest(sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<Self> {
    let fetchRequest = NSFetchRequest<Self>(entityName: self.entityName)
    fetchRequest.sortDescriptors = sortDescriptors ?? self.sortDescriptors
    return fetchRequest
  }
  
  static func newFetchRequest(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<Self> {
    let fetchRequest = self.newFetchRequest(sortDescriptors: sortDescriptors)
    fetchRequest.predicate = predicate
    return fetchRequest
  }
  
  static func fetchOne(predicate: NSPredicate? = nil) -> Self? {
    return self.fetch(predicate: predicate).first
  }
  
  static func fetchMany(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [Self] {
    return self.fetch(predicate: predicate, sortDescriptors: sortDescriptors ?? self.sortDescriptors)
  }
  
  static func fetchAll(sortDescriptors: [NSSortDescriptor]? = nil) -> [Self] {
    let request = self.newFetchRequest()
    request.sortDescriptors = sortDescriptors ?? self.sortDescriptors
    request.returnsObjectsAsFaults = false
    return self.fetch(sortDescriptors: sortDescriptors)
  }
  
  private static func fetch(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [Self] {
    let request = self.newFetchRequest()
    request.predicate = predicate
    request.sortDescriptors = sortDescriptors ?? self.sortDescriptors
    request.returnsObjectsAsFaults = false
    do {
      return try self.mainContext.fetch(request)
    } catch {
      print("\(self.entityName) : \(error.localizedDescription)")
    }
    return []
  }
  
  // MARK: - Fetched Results Controller
  
  static func newFetchedResultsController(predicate: NSPredicate? = nil, sectionNameKeyPath: String? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchedResultsController<Self> {
    let fetchRequest = self.newFetchRequest(predicate: predicate, sortDescriptors: sortDescriptors)
    return self.newFetchedResultsController(fetchRequest: fetchRequest, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors)
  }
  
  static func newFetchedResultsController(fetchRequest: NSFetchRequest<Self>, sectionNameKeyPath: String? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchedResultsController<Self> {
    fetchRequest.sortDescriptors = sortDescriptors ?? self.sortDescriptors
    return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.mainContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
  }
  
  // MARK: - Fetching Unique
  
  static func fetchManyUnique(properties: [String], predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [Any] {
    
    guard let request = self.newGenericFetchRequest() else {
      return []
    }
    
    request.predicate = predicate
    request.sortDescriptors = sortDescriptors ?? self.sortDescriptors
    request.resultType = .dictionaryResultType
    request.propertiesToFetch = properties
    request.returnsDistinctResults = true
    
    do {
      let result = try self.mainContext.fetch(request)
      
      guard let dictionaryArray = result as? [[AnyHashable : Any]] else {
        return []
      }
      
      var uniqueElements: [Any] = []
      for dictionary in dictionaryArray {
        for property in properties {
          if let value = dictionary[property] {
            uniqueElements.append(value)
          }
        }
      }
      return uniqueElements
      
    } catch {
      return []
    }
  }
  
  // MARK: - Deleting
  
  static func deleteOne(_ object: Self) {
    self.delete(object: object)
    self.saveMainContext()
  }
  
  static func deleteMany(predicate: NSPredicate? = nil) {
    for object in self.fetchMany(predicate: predicate) {
      self.delete(object: object)
    }
    self.saveMainContext()
  }
  
  static func deleteAll() {
    for object in self.fetchAll() {
      self.delete(object: object)
    }
    self.saveMainContext()
  }
  
  private static func delete(object: Self) {
    self.mainContext.delete(object)
  }
  
  func delete() {
    self.managedObjectContext?.delete(self)
  }
  
  // MARK: - Counting
  
  static func countAll() -> Int {
    return self.countMany()
  }
  
  private static func countMany(predicate: NSPredicate? = nil) -> Int {
    let request = self.newFetchRequest()
    request.predicate = predicate
    request.returnsObjectsAsFaults = false
    request.includesSubentities = false
    do {
      return try self.mainContext.count(for: request)
    } catch {
      return 0
    }
  }
}
