//
//  NFCTableViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class NFCTableViewController : BaseTableViewController {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> NFCTableViewController {
    return self.newViewController(fromStoryboardWithName: "NFC")
  }
  
  // MARK: - Properties
  
  let nfcReader = NFCReader()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Title
    self.navigationItem.title = "NFC Reader"
    self.navigationItem.largeTitleDisplayMode = .never
    
    // Navigation elements
    self.configureDefaultBackButton()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Scan", style: .plain, target: self, action: #selector(self.scanButtonSelected))
  }
  
  // MARK: - Actions
  
  @objc func scanButtonSelected() {
    self.nfcReader.beginSession()
  }
  
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return self.nfcReader.messageGroups.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let messageGroup = self.nfcReader.messageGroups[section]
    return messageGroup.messages.count
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let messageGroup = self.nfcReader.messageGroups[section]
    return messageGroup.detectionDate.shortDateTimeString
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NFCTableViewCell", for: indexPath) as! NFCTableViewCell
    let messageGroup = self.nfcReader.messageGroups[indexPath.section]
    let message = messageGroup.messages[indexPath.row]
    cell.titleLabel.text = "\(message.records.count) Records"
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    // Get the message group
    let messageGroup = self.nfcReader.messageGroups[indexPath.section]
    let message = messageGroup.messages[indexPath.row]
    
    // Transition to message detail
    let viewController = NFCMessageTableViewController.newViewController(message: message)
    viewController.presentIn(self, withMode: .navStack)
  }
}

extension NFCTableViewController : NFCReaderDelegate {
  
  func didDetectMessageGroup(_ reader: NFCReader, messageGroup: NFCMessageGroup) {}
  
  func didUpdateMessagesGroups(_ reader: NFCReader, messagesGroups: [NFCMessageGroup]) {
    self.tableView.reloadData()
  }
}
