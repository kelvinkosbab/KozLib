//
//  BaseTableViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class BaseTableViewController : UITableViewController, PresentableController {
  
  // MARK: - PresentableController
  
  var presentedMode: PresentationMode = .modal(.formSheet, .coverVertical)
  var presentationManager: UIViewControllerTransitioningDelegate?
  var currentFlowInitialController: PresentableController?
  
  // MARK: - UITableView
  
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}
