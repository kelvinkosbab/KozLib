//
//  TemperatureCollectionViewCell.swift
//  CollectionViewGraphing
//
//  Created by Brian Miller on 7/8/18.
//  Copyright © 2018 Brian Miller. All rights reserved.
//

import UIKit

class TemperatureCollectionViewCell: UICollectionViewCell {
  static let nibName = String(describing: TemperatureCollectionViewCell.self)
  static let reuseIdentifier = String(describing: TemperatureCollectionViewCell.self)
  
  static let phoneSize: CGSize = CGSize(width: 35, height: 35)
  static let padSize: CGSize = CGSize(width: 50, height: 50)
  
  @IBOutlet var tempLabel: UILabel!
  @IBOutlet var tempBackground: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    backgroundColor = .clear
    
    if UIDevice.current.isPhone {
      tempBackground.layer.cornerRadius = TemperatureCollectionViewCell.phoneSize.width / 2
    } else {
      tempBackground.layer.cornerRadius = TemperatureCollectionViewCell.padSize.width / 2
    }
    tempBackground.layer.borderWidth = 2
  }
  
  public func configure(with temperature: Temperature) {
    tempLabel.text = "\(temperature.temp)°"
    tempBackground.backgroundColor = temperature.isHigh ? UIColor.red.withAlphaComponent(0.7) : UIColor.blue.withAlphaComponent(0.5)
    tempBackground.layer.borderColor = temperature.isHigh ? UIColor.red.cgColor : UIColor.blue.cgColor
  }
}
