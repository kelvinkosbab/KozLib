//
//  StackedTitleDetailTableViewCell.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class StackedTitleDetailTableViewCell : UITableViewCell, Nibable {
  
  // MARK: - Properties
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var detailLabel: UILabel!
  
  func configure(title: String?, detail: String?, accessoryType: UITableViewCell.AccessoryType = .none) {
    self.titleLabel.text = title
    self.detailLabel.text = detail
    self.accessoryType = accessoryType
  }
}
