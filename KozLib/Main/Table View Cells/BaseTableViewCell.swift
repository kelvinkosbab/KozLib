//
//  BaseTableViewCell.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class BaseTableViewCell : UITableViewCell, Nibable {
  
  // MARK: - Properties
  
  @IBOutlet private weak var titleLabel: UILabel!
  
  func configure(title: String?, accessoryType: UITableViewCellAccessoryType = .none) {
    self.titleLabel.text = title
    self.accessoryType = accessoryType
  }
}
