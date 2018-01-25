//
//  NetworkInfoTableViewController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class NetworkInfoTableViewController : BaseTableViewController, NewViewControllerProtocol {
  
  // MARK: - NewViewControllerProtocol
  
  static let storyboardName: String = "Network"
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Network Info"
    self.navigationItem.largeTitleDisplayMode = .always
    
    self.configureDefaultBackButton()
    
    self.tableView.register(StackedTitleDetailTableViewCell.nib, forCellReuseIdentifier: StackedTitleDetailTableViewCell.identifier)
  }
  
  // MARK: - Properties
  
  enum NetworkItem {
    case ssid, radioTechnology, carrierName, carrierAllowsVOIP, carrierIsoCountryCode
    
    var title: String {
      switch self {
      case .ssid:
        return "SSID"
      case .radioTechnology:
        return "Radio Technology"
      case .carrierName:
        return "Name"
      case .carrierAllowsVOIP:
        return "Allows VOIP"
      case .carrierIsoCountryCode:
        return "ISO Country Code"
      }
    }
    
    var detail: String? {
      switch self {
      case .ssid:
        return Network.ssid
      case .radioTechnology:
        return Network.radioTechnology
      case .carrierName:
        return Network.cellularCarrier?.carrierName
      case .carrierAllowsVOIP:
        return (Network.cellularCarrier?.allowsVOIP ?? false) ? "Yes" : "No"
      case .carrierIsoCountryCode:
        return Network.cellularCarrier?.isoCountryCode
      }
    }
  }
  
  struct NetworkSectionItem {
    let sectionTitle: String?
    let items: [NetworkItem]
  }
  
  lazy var sectionItems: [NetworkSectionItem] = {
    var sectionItems: [NetworkSectionItem] = []
    sectionItems.append(NetworkSectionItem(sectionTitle: nil, items: [ .ssid, .radioTechnology ]))
    sectionItems.append(NetworkSectionItem(sectionTitle: "Carrier", items: [ .carrierName, .carrierAllowsVOIP, .carrierIsoCountryCode ]))
    return sectionItems
  }()
  
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return self.sectionItems.count
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let sectionItem = self.sectionItems[section]
    return sectionItem.sectionTitle
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionItem = self.sectionItems[section]
    return sectionItem.items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: StackedTitleDetailTableViewCell.identifier, for: indexPath) as! StackedTitleDetailTableViewCell
    let sectionItem = self.sectionItems[indexPath.section]
    let item = sectionItem.items[indexPath.row]
    cell.configure(title: item.title, detail: item.detail ?? "N/A")
    return cell
  }
}
