//
//  SimpleTableCell.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 11/18/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

struct SimpleTableCellViewModel {
  let image: UIImage?
  let title: String
  let subtitle: String
}

class SimpleTableCell: UITableViewCell {
  
  @IBOutlet weak var _imageView: UIImageView!
  @IBOutlet weak var _titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self._imageView.layer.cornerRadius = self._imageView.frame.height / 2
    self._imageView.layer.borderWidth = 1
    self._imageView.layer.borderColor = UIColor.lightGray.cgColor
    
  }
  
  func configure(model: SimpleTableCellViewModel) {
    self._titleLabel.text = model.title
    self.subtitleLabel.text = model.subtitle
    self.imageView?.image = model.image
  }
}
