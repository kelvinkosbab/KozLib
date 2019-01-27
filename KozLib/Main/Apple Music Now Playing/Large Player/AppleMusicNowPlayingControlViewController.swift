//
//  AppleMusicNowPlayingControlViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/26/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

class AppleMusicNowPlayingControlViewController : BaseViewController {
  
  // MARK: - Static Accessors
  
  private static func newViewController() -> AppleMusicNowPlayingControlViewController {
    return self.newViewController(fromStoryboardWithName: "AppleMusicNowPlaying")
  }
  
  static func newViewController(song: AppleMusicSong, coverArtImage: UIImage?) -> AppleMusicNowPlayingControlViewController {
    let viewController = self.newViewController()
    viewController.song = song
    viewController.coverArtImage = coverArtImage
    return viewController
  }
  
  // MARK: - Outlet Properties
  
  // MARK: - Properties
  
  var song: AppleMusicSong?
  var coverArtImage: UIImage?
  weak var delegate: AppleMusicNowPlayingMiniPlayerDelegate?
  
  // MARK: - Lifecycle
}
