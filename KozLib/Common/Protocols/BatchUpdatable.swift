//
//  BatchUpdatable.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 11/8/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class BatchUpdatableItem : Hashable {
  let id: Double
  let dataSourceUpdates: (() -> Void)?
  let batchUpdates: (() -> Void)?
  let completion: (() -> Void)?
  init(dataSourceUpdates: (() -> Void)? = nil, batchUpdates: (() -> Void)?, completion: (() -> Void)?) {
    self.id = Date.timeIntervalSinceReferenceDate
    self.dataSourceUpdates = dataSourceUpdates
    self.batchUpdates = batchUpdates
    self.completion = completion
  }
  
  var hashValue: Int {
    return self.id.hashValue
  }
  
  static func == (lhs: BatchUpdatableItem, rhs: BatchUpdatableItem) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

protocol BatchUpdatable : class {
  var isProcessingBatchUpdate: Bool { get set }
  var batchUpdateQueue: [BatchUpdatableItem] { get set }
}

protocol BatchUpdatableTableController : BatchUpdatable {
  weak var tableView: UITableView! { get set }
}

protocol BatchUpdatableCollectionController : BatchUpdatable {
  weak var collectionView: UICollectionView! { get set }
}

extension BatchUpdatable {
  
  private var tableView: UITableView? {
    if let batchUpdatableTableController = self as? BatchUpdatableTableController {
      return batchUpdatableTableController.tableView
    } else if let tableViewController = self as? UITableViewController {
      return tableViewController.tableView
    }
    return nil
  }
  
  private var collectionView: UICollectionView? {
    if let batchUpdatableCollectionController = self as? BatchUpdatableCollectionController {
      return batchUpdatableCollectionController.collectionView
    } else if let collectionViewController = self as? UICollectionViewController {
      return collectionViewController.collectionView
    }
    return nil
  }
  
  func perform(dataSourceUpdates: (() -> Void)? = nil, batchUpdates: (() -> Void)?, completion: (() -> Void)? = nil) {
    
    // Updatable item
    let item = BatchUpdatableItem(dataSourceUpdates: dataSourceUpdates, batchUpdates: batchUpdates, completion: completion)
    self.batchUpdateQueue.append(item)
    
    // Check if currently processing an item
    guard !self.isProcessingBatchUpdate else {
      return
    }
    
    // Perform the update
    self.performNextBatchUpdate()
  }
  
  private func performNextBatchUpdate() {
    
    // Check if there is anything else to process
    guard self.batchUpdateQueue.count > 0 else {
      self.isProcessingBatchUpdate = false
      self.tableView?.allowsSelection = true
      self.collectionView?.allowsSelection = true
      return
    }
    
    // Set processing and selection flags
    self.tableView?.allowsSelection = false
    self.collectionView?.allowsSelection = false
    self.isProcessingBatchUpdate = true
    
    // Process the next item
    let item: BatchUpdatableItem? = self.batchUpdateQueue.removeFirst()
    
    // Execute data updates
    item?.dataSourceUpdates?()
    
    // Updates for table views
    if let tableView = self.tableView {
      
      if #available(iOS 11.0, *) {
        tableView.performBatchUpdates({
          item?.batchUpdates?()
        }) { [weak self] _ in
          item?.completion?()
          self?.performNextBatchUpdate()
        }
        
      } else {
        
        // Pre-iOS 11
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
          item?.completion?()
          self?.performNextBatchUpdate()
        }
        tableView.beginUpdates()
        item?.batchUpdates?()
        tableView.endUpdates()
        CATransaction.commit()
      }
    }
    
    // Updates for collection views
    self.collectionView?.performBatchUpdates(item?.batchUpdates) { [weak self] _ in
      item?.completion?()
      self?.performNextBatchUpdate()
    }
  }
}
