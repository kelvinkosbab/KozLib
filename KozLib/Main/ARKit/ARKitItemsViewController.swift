//
//  ARKitItemsViewController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class ARKitItemsViewController : BaseTableViewController, ARKitNavigationDelegate {
  
  // MARK: - Class Accessors
  
  static func newViewController() -> ARKitItemsViewController {
    return self.newViewController(fromStoryboardWithName: "ARKit")
  }
  
  // MARK: - Properties
  
  enum ARKitItem {
    case visualizingPlaneDetection
    
    var title: String {
      switch self {
      case .visualizingPlaneDetection:
        return "Visualizing Plane Detection"
      }
    }
    
    func getViewController() -> UIViewController {
      switch self {
      case .visualizingPlaneDetection:
        return ARPlaneMappingViewController.newViewController()
      }
    }
  }
  
  let items: [ARKitItem] = [ .visualizingPlaneDetection ]
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "ARKit Projects"
    self.navigationItem.largeTitleDisplayMode = .always
    
    self.configureDefaultBackButton()
    
    self.tableView.register(BaseTableViewCell.nib, forCellReuseIdentifier: BaseTableViewCell.identifier)
  }
  
  // MARK: - Navigation
  
  func transitionToPlaneMapping() {
    let viewController = ARPlaneMappingViewController.newViewController()
    self.present(viewController: viewController, withMode: .rightToLeft, dismissInteractiveView: viewController.view)
  }
}

// MARK: - UITableView

extension ARKitItemsViewController {
  
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
    case .visualizingPlaneDetection:
      self.transitionToPlaneVisualization()
      break
    }
  }
}
