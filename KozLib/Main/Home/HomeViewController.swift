//
//  HomeViewController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class HomeViewController : BaseTableViewController, ARKitNavigationDelegate, NFCNavigationDelegate, NetworkNavigationDelegate {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> HomeViewController {
    return self.newViewController(fromStoryboardWithName: "Main")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "KozLibrary"
    self.navigationItem.largeTitleDisplayMode = .always
    
    self.configureDefaultBackButton()
    
    self.tableView.register(BaseTableViewCell.nib, forCellReuseIdentifier: BaseTableViewCell.identifier)
  }
  
  // MARK: - SectionType
  
  enum SectionType {
    case misc, network
    
    var title: String? {
      switch self {
      case .misc:
        return nil
      case .network:
        return "Network"
      }
    }
  }
  
  func getSectionType(section: Int) -> SectionType? {
    switch section {
    case 0:
      return .misc
    case 1:
      return .network
    default:
      return nil
    }
  }
  
  // MARK: - RowType
  
  enum RowType {
    case arKit, nfc, basicNetwork, networkExtension
    
    var title: String {
      switch self {
      case .arKit:
        return "ARKit Projects"
      case .nfc:
        return "NFC Reader"
      case .basicNetwork:
        return "Basic Network Info"
      case .networkExtension:
        return "Network Extension"
      }
    }
  }
  
  func getRowType(at indexPath: IndexPath) -> RowType? {
    
    guard let sectionType = self.getSectionType(section: indexPath.section) else {
      return nil
    }
    
    switch sectionType {
    case .misc:
      switch indexPath.row {
      case 0:
        return .arKit
      case 1:
        return .nfc
      default:
        return nil
      }
    case .network:
      switch indexPath.row {
      case 0:
        return .basicNetwork
      case 1:
        return .networkExtension
      default:
        return nil
      }
    }
  }
  
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    guard let sectionType = self.getSectionType(section: section) else {
      return nil
    }
    
    return sectionType.title
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let sectionType = self.getSectionType(section: section) else {
      return 0
    }
    
    switch sectionType {
    case .misc:
      return 2
    case .network:
      return 2
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
    case .arKit:
      self.transitionToARKitItems(presentationMode: .navStack)
    case .nfc:
      self.transitionToNFC(presentationMode: .navStack)
    case .basicNetwork:
      self.transitionToNetworkInfo(presentationMode: .navStack)
    case .networkExtension:
      self.transitionToNetworkExtension(presentationMode: .navStack)
    }
  }
}
