//
//  ARKitItemsViewController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class ARKitItemsViewController : BaseTableViewController, NewViewControllerProtocol, ARKitNavigationDelegate {
  
  // MARK: - NewViewControllerProtocol
  
  static let storyboardName: String = "ARKit"
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "ARKit Projects"
    self.navigationItem.largeTitleDisplayMode = .always
    
    self.configureDefaultBackButton()
    
    self.tableView.register(BaseTableViewCell.nib, forCellReuseIdentifier: BaseTableViewCell.identifier)
  }
  
  // MARK: - SectionType
  
  enum SectionType {
    case list
  }
  
  func getSectionType(section: Int) -> SectionType? {
    switch section {
    case 0:
      return .list
    default:
      return nil
    }
  }
  
  // MARK: - RowType
  
  enum RowType {
    case visualizingPlaneDetection, blockPhysics, planeMapping
    
    var title: String {
      switch self {
      case .visualizingPlaneDetection:
        return "Visualizing Plane Detection"
      case .blockPhysics:
        return "Block Physics"
      case .planeMapping:
        return "Plane Mapping"
      }
    }
  }
  
  func getRowType(at indexPath: IndexPath) -> RowType? {
    
    guard let sectionType = self.getSectionType(section: indexPath.section) else {
      return nil
    }
    
    switch sectionType {
    case .list:
      switch indexPath.row {
      case 0:
        return .visualizingPlaneDetection
      case 1:
        return .blockPhysics
      case 2:
        return .planeMapping
      default:
        return nil
      }
    default:
      return nil
    }
  }
}

// MARK: - UITableView

extension ARKitItemsViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let sectionType = self.getSectionType(section: section) else {
      return 0
    }
    
    switch sectionType {
    case .list:
      return 3
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let rowType = self.getRowType(at: indexPath) else {
      let cell = UITableViewCell()
      cell.contentView.backgroundColor = tableView.backgroundColor
      return cell
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewCell.identifier, for: indexPath) as! BaseTableViewCell
    cell.configure(title: rowType.title, accessoryType: .disclosureIndicator)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    guard let rowType = self.getRowType(at: indexPath) else {
      return
    }
    
    switch rowType {
    case .visualizingPlaneDetection:
      self.transitionToARPlaneVisualization()
    case .blockPhysics:
      self.transitionToARBlockPhysics()
    case .planeMapping:
      self.transitionToPlaneMapping()
    }
  }
}
