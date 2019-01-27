//
//  AppleMusicNowPlayingContainerViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/26/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

class AppleMusicNowPlayingContainerViewController : BaseViewController {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> AppleMusicNowPlayingContainerViewController {
    return self.newViewController(fromStoryboardWithName: "AppleMusicNowPlaying")
  }
  
  // MARK: - View Properties
  
  @IBOutlet weak var songListContainer: UIView!
  weak var miniPlayerContainer: UIView?
  
  // MARK: - Properties
  
  internal var currentSong: AppleMusicSong?
  internal var miniPlayerViewController: AppleMusicNowPlayingMiniPlayerViewController?
  
  internal var isMiniPlayerHidden: Bool {
    return self.miniPlayerContainer == nil
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Music Library"
    self.configureDefaultBackButton()
    self.configureLargeNavigationTitle()
    
    self.configureSongList()
  }
  
  // MARK: - Child View Controllers
  
  private func configureSongList() {
    let viewController = AppleMusicNowPlayingSongListViewController.newViewController(delegate: self)
    self.add(childViewController: viewController, intoContainerView: self.songListContainer)
  }
}

// MARK: - Now Playihng Container

extension AppleMusicNowPlayingContainerViewController {
  
  func showMiniPlayer(song: AppleMusicSong, coverArtImage: UIImage?, completion: @escaping () -> Void) {
    
    guard self.isMiniPlayerHidden else {
      DispatchQueue.main.async { [weak self] in
        self?.miniPlayerViewController?.update(song: song, coverArtImage: coverArtImage)
        completion()
      }
      return
    }
    
    let effect = UIBlurEffect(style: .regular)
    
    let miniPlayerBackgroundView = UIVisualEffectView(effect: self.tabBarController == nil ? effect : nil)
    miniPlayerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(miniPlayerBackgroundView)
    self.miniPlayerContainer = miniPlayerBackgroundView
    
    NSLayoutConstraint.activate([
      self.view.leadingAnchor.constraint(equalTo: miniPlayerBackgroundView.leadingAnchor, constant: 0),
      self.view.trailingAnchor.constraint(equalTo: miniPlayerBackgroundView.trailingAnchor, constant: 0),
      self.view.bottomAnchor.constraint(equalTo: miniPlayerBackgroundView.bottomAnchor, constant: 0)
      ])
    
    let miniPlayerContainerView = UIVisualEffectView(effect: self.tabBarController == nil ? nil : effect)
    miniPlayerContainerView.translatesAutoresizingMaskIntoConstraints = false
    miniPlayerBackgroundView.contentView.addSubview(miniPlayerContainerView)
    miniPlayerContainerView.contentView.backgroundColor = .clear

    NSLayoutConstraint.activate([
      miniPlayerContainerView.heightAnchor.constraint(equalToConstant: 60),
      miniPlayerBackgroundView.contentView.topAnchor.constraint(equalTo: miniPlayerContainerView.topAnchor, constant: 0),
      miniPlayerBackgroundView.contentView.leadingAnchor.constraint(equalTo: miniPlayerContainerView.leadingAnchor, constant: 0),
      miniPlayerBackgroundView.contentView.trailingAnchor.constraint(equalTo: miniPlayerContainerView.trailingAnchor, constant: 0),
      miniPlayerBackgroundView.contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: miniPlayerContainerView.bottomAnchor, constant: 0)
      ])
    
    // Configure the mini player view controller
    let viewController = AppleMusicNowPlayingMiniPlayerViewController.newViewController(song: song, coverArtImage: coverArtImage, delegate: self)
    self.miniPlayerViewController = viewController
    self.add(childViewController: viewController, intoContainerView: miniPlayerContainerView.contentView)
    
    // Animate show the content
    miniPlayerBackgroundView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 60)
    miniPlayerContainerView.frame = CGRect(x: 0, y: 0, width: miniPlayerBackgroundView.frame.width, height: miniPlayerBackgroundView.frame.height)
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: .curveEaseOut, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { _ in
      completion()
    }
  }
  
  func hideMiniPlayer(completion: @escaping () -> Void) {
    
    guard !self.isMiniPlayerHidden else {
      DispatchQueue.main.async {
        completion()
      }
      return
    }
    
    UIView.animate(withDuration: 0.2, animations: { [weak self] in
      if let strongSelf = self {
        strongSelf.miniPlayerContainer?.frame.origin.y = strongSelf.view.bounds.height
      }
    }) { [weak self] _ in
      if let viewController = self?.miniPlayerViewController {
        self?.remove(childViewController: viewController)
      }
      self?.miniPlayerContainer?.removeFromSuperview()
      completion()
    }
  }
}

// MARK: - AppleMusicNowPlayingSelectSongDelegate

extension AppleMusicNowPlayingContainerViewController : AppleMusicNowPlayingSelectSongDelegate {
  
  func didSelect(song: AppleMusicSong, coverArtImage: UIImage?) {
    
    // Set the current song
    self.currentSong = song
    
    // Haptic
    HapticsGenerator().generate(.impact(.light))
    
    // Mini player
    self.showMiniPlayer(song: song, coverArtImage: coverArtImage) {}
  }
}

// MARK: - AppleMusicNowPlayingMiniPlayerDelegate

extension AppleMusicNowPlayingContainerViewController : AppleMusicNowPlayingMiniPlayerDelegate {
  
  func miniPlayerDidSelect(song: AppleMusicSong, coverArtImage: UIImage?) {
    
    // Haptic
    HapticsGenerator().generate(.impact(.medium))
    
    // Preset large player
    self.presentAppleMusicLargePlayer(song: song, coverArtImage: coverArtImage)
  }
  
  private func presentAppleMusicLargePlayer(song: AppleMusicSong, coverArtImage: UIImage?) {
    let viewController = AppleMusicNowPlayingControlViewController.newViewController(song: song, coverArtImage: coverArtImage)
    viewController.presentIn(self, withMode: .modal(.overFullScreen, .coverVertical))
  }
}
