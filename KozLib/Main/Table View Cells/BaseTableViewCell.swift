//
//  BaseTableViewCell.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class BaseTableViewCell : UITableViewCell {
  
  // MARK: - Static Accessors
  
  static let identifier: String = "BaseTableViewCell"
  
  static var nib: UINib {
    return UINib(nibName: self.identifier, bundle: nil)
  }
  
  // MARK: - Properties
  
  @IBOutlet private weak var titleLabel: UILabel!
  
  func configure(title: String?, accessoryType: UITableViewCellAccessoryType = .none) {
    self.titleLabel.text = title
    self.accessoryType = accessoryType
  }
}
