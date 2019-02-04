//
//  AppleMusicNowPlayingMiniPlayerViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/26/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

protocol AppleMusicNowPlayingMiniPlayerDelegate: class {
  func miniPlayerDidSelect(song: AppleMusicSong)
}

class AppleMusicNowPlayingMiniPlayerViewController : BaseViewController {
  
  // MARK: - Static Accessors
  
  private static func newViewController() -> AppleMusicNowPlayingMiniPlayerViewController {
    return self.newViewController(fromStoryboardWithName: "AppleMusicNowPlaying")
  }
  
  static func newViewController(song: AppleMusicSong, containerHeight: CGFloat, delegate: AppleMusicNowPlayingMiniPlayerDelegate) -> AppleMusicNowPlayingMiniPlayerViewController {
    let viewController = self.newViewController()
    viewController.delegate = delegate
    viewController.containerHeight = containerHeight
    viewController.update(song: song)
    return viewController
  }
  
  // MARK: - Outlet Properties
  
  @IBOutlet weak var songButton: UIButton!
  @IBOutlet weak var coverArtImageView: UIImageView!
  @IBOutlet weak var coverArtImageViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var coverArtImageViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var songNameLabel: UILabel!
  @IBOutlet weak var playPauseButton: AppleMusicButton!
  @IBOutlet weak var skipButton: AppleMusicButton!
  
  // MARK: - Properties
  
  var song: AppleMusicSong?
  var containerHeight: CGFloat = 100
  weak var delegate: AppleMusicNowPlayingMiniPlayerDelegate?
  
  internal lazy var playImage: UIImage? = {
    return UIImage(named: "icPlay")?.withRenderingMode(.alwaysTemplate)
  }()
  
  internal lazy var pauseImage: UIImage? = {
    return UIImage(named: "icPause")?.withRenderingMode(.alwaysTemplate)
  }()
  
  internal lazy var skipImage: UIImage? = {
    return UIImage(named: "icSkipForward")?.withRenderingMode(.alwaysTemplate)
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.updateContent()
  }
  
  // MARK: - Configuration
  
  private func configureViews() {
    self.view.backgroundColor = .clear
    self.songNameLabel.text = nil
    self.coverArtImageViewWidthConstraint.constant = self.containerHeight - 16
    self.coverArtImageViewHeightConstraint.constant = self.containerHeight - 16
    
    self.playPauseButton.setImage(self.playImage, for: .normal)
    self.playPauseButton.tintColor = .black
    self.skipButton.setImage(self.skipImage, for: .normal)
    self.skipButton.tintColor = .black
  }
  
  // MARK: - Updating Content
  
  func update(song: AppleMusicSong) {
    self.song = song
    
    guard self.isViewLoaded else {
      return
    }
    
    self.updateContent()
  }
  
  private func updateContent() {
    
    guard let song = self.song else {
      self.view.isHidden = true
      return
    }
    
    if let imageName = song.imageName, let image = UIImage(named: imageName) {
      self.coverArtImageView.backgroundColor = .clear
      self.coverArtImageView.image = image
    } else {
      self.coverArtImageView.backgroundColor = .lightGray
      self.coverArtImageView.image = nil
    }
    self.songNameLabel.text = song.title
  }
}

// MARK: - Actions

extension AppleMusicNowPlayingMiniPlayerViewController {
  
  @IBAction func songButtonPressed() {
    
    guard let song = self.song else {
      return
    }
    
    self.delegate?.miniPlayerDidSelect(song: song)
  }
  
  @IBAction func playPauseButtonPressed() {
    
  }
  
  @IBAction func skipButtonPressed() {
    
  }
}

// MARK: - MaxiPlayerSourceProtocol

extension AppleMusicNowPlayingMiniPlayerViewController : AppleMusicLargePlayerSourceProtocol {
  
  var originatingFrameInWindow: CGRect {
    return self.view.convert(self.view.frame, to: nil)
  }
  
  var originatingCoverImageView: UIImageView? {
    return self.coverArtImageView
  }
}
