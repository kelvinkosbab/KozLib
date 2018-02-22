//
//  ARKitItemsViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit
import ARKit

class ARKitItemsViewController : BaseTableViewController, ARKitNavigationDelegate {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> ARKitItemsViewController {
    return self.newViewController(fromStoryboardWithName: "ARKit")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "ARKit Projects"
    self.navigationItem.largeTitleDisplayMode = .always
    
    self.configureDefaultBackButton()
    
    self.tableView.register(BaseTableViewCell.nib, forCellReuseIdentifier: BaseTableViewCell.identifier)
    self.tableView.register(StackedTitleDetailTableViewCell.nib, forCellReuseIdentifier: StackedTitleDetailTableViewCell.identifier)
  }
  
  // MARK: - SectionType
  
  enum SectionType {
    case horizontal, vertical, faceTracking
    
    var sectionTitle: String {
      switch self {
      case .horizontal:
        return "Horizontal"
      case .vertical:
        return "Vertical"
      case .faceTracking:
        return "Face Tracking"
      }
    }
  }
  
  func getSectionType(section: Int) -> SectionType? {
    switch section {
    case 0:
      return .horizontal
    case 1:
      return .vertical
    case 2:
      return .faceTracking
    default:
      return nil
    }
  }
  
  // MARK: - RowType
  
  enum RowType {
    case horizontalSurfaceVisualization, blockPhysics, planeMapping, tackDragonDemo, wallDetection, faceMappingVisulalization
    
    var title: String {
      switch self {
      case .horizontalSurfaceVisualization:
        return "Visualizing Plane Detection"
      case .blockPhysics:
        return "Block Physics"
      case .planeMapping:
        return "Plane Mapping"
      case .tackDragonDemo:
        return "Kozinga AR Dragon Demo"
      case .wallDetection:
        return "Wall Detection"
      case .faceMappingVisulalization:
        return "Face Tracking"
      }
    }
  }
  
  func getRowType(at indexPath: IndexPath) -> RowType? {
    
    guard let sectionType = self.getSectionType(section: indexPath.section) else {
      return nil
    }
    
    switch sectionType {
    case .horizontal:
      switch indexPath.row {
      case 0:
        return .horizontalSurfaceVisualization
      case 1:
        return .blockPhysics
      case 2:
        return .planeMapping
      case 3:
        return .tackDragonDemo
      default:
        return nil
      }
    case .vertical:
      switch indexPath.row {
      case 0:
        return .wallDetection
      default:
        return nil
      }
    case .faceTracking:
      switch indexPath.row {
      case 0:
        return .faceMappingVisulalization
      default:
        return nil
      }
    }
  }
}

// MARK: - UITableView

extension ARKitItemsViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    guard let sectionType = self.getSectionType(section: section) else {
      return nil
    }
    
    return sectionType.sectionTitle
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let sectionType = self.getSectionType(section: section) else {
      return 0
    }
    
    switch sectionType {
    case .horizontal:
      return 4
    case .vertical:
      return 1
    case .faceTracking:
      return 1
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let rowType = self.getRowType(at: indexPath) else {
      let cell = UITableViewCell()
      cell.contentView.backgroundColor = tableView.backgroundColor
      return cell
    }
    
    switch rowType {
    case .blockPhysics, .horizontalSurfaceVisualization, .planeMapping, .tackDragonDemo, .wallDetection:
      let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewCell.identifier, for: indexPath) as! BaseTableViewCell
      cell.configure(title: rowType.title, accessoryType: .disclosureIndicator)
      return cell
      
    case .faceMappingVisulalization:
      if ARFaceTrackingConfiguration.isSupported {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewCell.identifier, for: indexPath) as! BaseTableViewCell
        cell.configure(title: rowType.title, accessoryType: .disclosureIndicator)
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: StackedTitleDetailTableViewCell.identifier, for: indexPath) as! StackedTitleDetailTableViewCell
        cell.configure(title: rowType.title, detail: "This feature requires true-depth front-facing camera.", accessoryType: .none)
        return cell
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    guard let rowType = self.getRowType(at: indexPath) else {
      return
    }
    
    switch rowType {
    case .horizontalSurfaceVisualization:
      self.transitionToARPlaneVisualization()
    case .blockPhysics:
      self.transitionToARBlockPhysics()
    case .planeMapping:
      self.transitionToPlaneMapping()
    case .tackDragonDemo:
      self.transitionToDragonDemo()
    case .wallDetection:
      self.transitionToWallDetection()
    case .faceMappingVisulalization:
      
      guard ARFaceTrackingConfiguration.isSupported else {
        let arState = ARState.unsupported(.faceTracking)
        let alertController = UIAlertController(title: arState.status, message: arState.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        return
      }
      
      self.transitionToARFaceTracking()
    }
  }
}
