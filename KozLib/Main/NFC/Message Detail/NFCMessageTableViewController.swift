//
//  NFCMessageTableViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit
import CoreNFC

class NFCMessageTableViewController : BaseTableViewController {
  
  // MARK: - Class Accessors
  
  private static func newViewController() -> NFCMessageTableViewController {
    return self.newViewController(fromStoryboardWithName: "NFC")
  }
  
  static func newViewController(message: NFCNDEFMessage) -> NFCMessageTableViewController {
    let viewController = self.newViewController()
    viewController.message = message
    return viewController
  }
  
  // MARK: - Properties
  
  var message: NFCNDEFMessage!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "NFC Message Detail"
  }
  
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return self.message.records.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CoreNFCTableViewCell", for: indexPath) as! NFCTableViewCell
    let record = self.message.records[indexPath.section]
    switch indexPath.row {
    case 0:
      let description = String(describing: String(data: record.identifier, encoding: .utf8) ?? "")
      cell.titleLabel.text = "\(indexPath.row + 1) : \(description)"
      break
    case 1:
      let description = String(describing: String(data: record.payload, encoding: .utf8) ?? "")
      cell.titleLabel.text = "\(indexPath.row + 1) : \(description)"
      break
    case 2:
      let description = String(describing: String(data: record.type, encoding: .utf8) ?? "")
      cell.titleLabel.text = "\(indexPath.row + 1) : \(description)"
      break
    case 3:
      let description = String(describing: record.typeNameFormat)
      cell.titleLabel.text = "\(indexPath.row + 1) : \(description)"
      break
    default:
      cell.titleLabel.text = nil
      break
    }
    return cell
  }
}
