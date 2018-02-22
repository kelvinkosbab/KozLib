//
//  DataMangerProtocol.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import CoreData

protocol DataMangerProtocol {
  var persistentContainerName: String { get }
  var persistentContainer: NSPersistentContainer { get }
}

extension DataMangerProtocol {
  
  // MARK: - Persistent Container
  
  func getPersistentContainer() -> NSPersistentContainer {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: self.persistentContainerName)
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        //fatalError("Unresolved error \(error), \(error.userInfo)")
        print("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }
  
  // MARK: - Context
  
  var mainContext: NSManagedObjectContext {
    return self.persistentContainer.viewContext
  }
  
  func save(context: NSManagedObjectContext) {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        print("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  func saveMainContext() {
    self.save(context: self.mainContext)
  }
}
