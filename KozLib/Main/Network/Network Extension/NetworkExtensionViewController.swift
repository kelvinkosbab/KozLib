//
//  NetworkExtensionViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit
import NetworkExtension

class NetworkExtensionViewController : BaseTableViewController {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> NetworkExtensionViewController {
    return self.newViewController(fromStoryboardWithName: "Network")
  }
  
  // MARK - Properties
  
  let hotspotHelper = HotspotHelper()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Network Extension"
    self.navigationItem.largeTitleDisplayMode = .always
    
    self.configureDefaultBackButton()
    
    self.tableView.register(StackedTitleDetailTableViewCell.nib, forCellReuseIdentifier: StackedTitleDetailTableViewCell.identifier)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.hotspotHelper.scanForNetworks { (command, networks) in }
  }
  
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 0
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: StackedTitleDetailTableViewCell.identifier, for: indexPath) as! StackedTitleDetailTableViewCell
//    cell.configure(title: item.title, detail: item.detail ?? "N/A")
    return cell
  }
}
