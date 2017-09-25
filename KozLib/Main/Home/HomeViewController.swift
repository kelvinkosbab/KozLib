//
//  HomeViewController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class HomeViewController : BaseTableViewController {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> HomeViewController {
    return self.newViewController(fromStoryboardWithName: "Main")
  }
  
  // MARK: - Properties
  
  let items = HomeListItem.all
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "KozLib"
    
    self.configureDefaultBackButton()
  }
  
  // MARK: - UITableView
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableListCell", for: indexPath) as! HomeTableListCell
    let item = self.items[indexPath.row]
    cell.configure(item: item)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let item = self.items[indexPath.row]
    switch item {
    case .arKitPlaneMapping:
      self.transtionToARKitPlaneMapping()
      break
    case .nfc:
      self.transitionToNfc()
      break
    case .transparentNavigationBar:
      break
    case .expandingNavigationBar:
      break
    }
  }
  
  // MARK: - Navigation
  
  func transitionToNfc() {
    let viewController = NFCTableViewController.newViewController()
    self.present(viewController: viewController, withMode: .navStack)
  }
  
  func transtionToARKitPlaneMapping() {
    let viewController = ARPlaneMappingViewController.newViewController()
    self.present(viewController: viewController, withMode: .navStack)
  }
}

class HomeTableListCell : UITableViewCell {
  @IBOutlet weak private var titleLabel: UILabel!
  
  func configure(item: HomeListItem) {
    self.titleLabel.text = item.title
  }
}
