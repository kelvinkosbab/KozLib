//
//  HomeViewController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class HomeViewController : BaseTableViewController, ARKitNavigationDelegate, NFCNavigationDelegate, NetworkInfoNavigationDelegate {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> HomeViewController {
    return self.newViewController(fromStoryboardWithName: "Main")
  }
  
  // MARK: - Properties
  
  enum HomeListItem {
    case nfc, arKit, transparentNavigationBar, expandingNavigationBar, networkInfo
    
    var title: String {
      switch self {
      case .arKit:
        return "ARKit Projects"
      case .nfc:
        return "NFC Reader"
      case .transparentNavigationBar, .expandingNavigationBar:
        return "TBD"
      case .networkInfo:
        return "Network Info"
      }
    }
  }
  
  let items: [HomeListItem] = [ .arKit, .nfc, .networkInfo ]
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "KozLibrary"
    self.navigationItem.largeTitleDisplayMode = .always
    
    self.configureDefaultBackButton()
    
    self.tableView.register(BaseTableViewCell.nib, forCellReuseIdentifier: BaseTableViewCell.identifier)
  }
  
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewCell.identifier, for: indexPath) as! BaseTableViewCell
    let item = self.items[indexPath.row]
    cell.configure(title: item.title, accessoryType: .disclosureIndicator)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let item = self.items[indexPath.row]
    switch item {
    case .arKit:
      self.transitionToARKitItems(presentationMode: .navStack)
    case .nfc:
      self.transitionToNFC(presentationMode: .navStack)
    case .networkInfo:
      self.transitionToNetworkInfo(presentationMode: .navStack)
    case .expandingNavigationBar, .transparentNavigationBar: break
    }
  }
}
