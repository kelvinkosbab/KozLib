//
//  AppleMusicNowPlayingLargePlayerCoverArtCell.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/27/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

class AppleMusicNowPlayingLargePlayerCoverArtCell : UITableViewCell, ClassNamable {
  
  @IBOutlet private weak var coverArtImageViewContainer: UIView!
  @IBOutlet private weak var coverArtImageViewContainerWidth: NSLayoutConstraint!
  @IBOutlet private weak var coverArtImageViewContainerHeight: NSLayoutConstraint!
  @IBOutlet weak var coverArtImageView: UIImageView!
  
  func configure(coverArtImage: UIImage?, rowHeight: CGFloat) {
    self.coverArtImageView.image = coverArtImage
    
    let aspectRatio: CGFloat = {
      if let coverArtImage = coverArtImage {
        return coverArtImage.size.width / coverArtImage.size.height
      } else {
        return 1
      }
    }()
    
    let margin: CGFloat = 16
    let maxImageSize = rowHeight - (margin * 2)
    self.coverArtImageViewContainerWidth.constant = aspectRatio > 1 ? maxImageSize : maxImageSize * aspectRatio
    self.coverArtImageViewContainerHeight.constant = aspectRatio < 1 ? maxImageSize : maxImageSize / aspectRatio
    self.contentView.layoutIfNeeded()
    
    self.coverArtImageView.clipsToBounds = true
    self.coverArtImageView.layer.cornerRadius = 12
    self.coverArtImageView.layer.masksToBounds = true
    
    self.coverArtImageViewContainer.clipsToBounds = false
    self.coverArtImageViewContainer.layer.cornerRadius = 12
    self.coverArtImageViewContainer.layer.shadowColor = UIColor.gray.cgColor
    self.coverArtImageViewContainer.layer.shadowOpacity = 0.8
    self.coverArtImageViewContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
    self.coverArtImageViewContainer.layer.shadowRadius = 4
  }
}
