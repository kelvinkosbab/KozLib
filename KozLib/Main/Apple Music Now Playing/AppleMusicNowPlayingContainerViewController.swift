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
  weak var miniPlayerContainerView: UIView?
  
  // MARK: - Properties
  
  internal var currentSong: AppleMusicSong?
  
  internal var isMiniPlayerHidden: Bool {
    return self.miniPlayerContainerView == nil
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
  
  func showMiniPlayer(completion: @escaping () -> Void) {
    
    guard self.isMiniPlayerHidden else {
      DispatchQueue.main.async {
        completion()
      }
      return
    }
    
    let miniPlayerBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    miniPlayerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(miniPlayerBackgroundView)
    self.miniPlayerContainerView = miniPlayerBackgroundView
    
    NSLayoutConstraint.activate([
      self.view.leadingAnchor.constraint(equalTo: miniPlayerBackgroundView.leadingAnchor, constant: 0),
      self.view.trailingAnchor.constraint(equalTo: miniPlayerBackgroundView.trailingAnchor, constant: 0),
      self.view.bottomAnchor.constraint(equalTo: miniPlayerBackgroundView.bottomAnchor, constant: 0)
      ])
    
    let miniPlayerContainerView = UIView()
    miniPlayerContainerView.translatesAutoresizingMaskIntoConstraints = false
    miniPlayerBackgroundView.contentView.addSubview(miniPlayerContainerView)
    miniPlayerContainerView.backgroundColor = .clear

    NSLayoutConstraint.activate([
      miniPlayerContainerView.heightAnchor.constraint(equalToConstant: 100),
      miniPlayerBackgroundView.contentView.topAnchor.constraint(equalTo: miniPlayerContainerView.topAnchor, constant: 0),
      miniPlayerBackgroundView.contentView.leadingAnchor.constraint(equalTo: miniPlayerContainerView.leadingAnchor, constant: 0),
      miniPlayerBackgroundView.contentView.trailingAnchor.constraint(equalTo: miniPlayerContainerView.trailingAnchor, constant: 0),
      miniPlayerBackgroundView.contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: miniPlayerContainerView.bottomAnchor, constant: 0)
      ])
    
    // Animate show the content
    miniPlayerBackgroundView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 100)
    miniPlayerContainerView.frame = CGRect(x: 0, y: 0, width: miniPlayerBackgroundView.frame.width, height: miniPlayerBackgroundView.frame.height)
    UIView.animate(withDuration: 0.2, animations: { [weak self] in
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
        strongSelf.miniPlayerContainerView?.frame.origin.y = strongSelf.view.bounds.height
      }
    }) { [weak self] _ in
      self?.miniPlayerContainerView?.removeFromSuperview()
      completion()
    }
  }
}

// MARK: - AppleMusicNowPlayingSelectSongDelegate

extension AppleMusicNowPlayingContainerViewController : AppleMusicNowPlayingSelectSongDelegate {
  
  func didSelect(song: AppleMusicSong) {
    self.currentSong = song
    
    if self.isMiniPlayerHidden {
      self.showMiniPlayer { }
    } else {
      self.hideMiniPlayer { }
    }
  }
}
