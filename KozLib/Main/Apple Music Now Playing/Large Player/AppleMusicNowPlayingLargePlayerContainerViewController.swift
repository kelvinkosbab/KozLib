//
//  AppleMusicNowPlayingLargePlayerContainerViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/4/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

class AppleMusicNowPlayingLargePlayerContainerViewController : BaseViewController {
  
  // MARK: - Static Accessors
  
  private static func newViewController() -> AppleMusicNowPlayingLargePlayerContainerViewController {
    return self.newViewController(fromStoryboardWithName: "AppleMusicNowPlaying")
  }
  
  static func newViewController(song: AppleMusicSong?) -> AppleMusicNowPlayingLargePlayerContainerViewController {
    let viewController = self.newViewController()
    viewController.song = song
    return viewController
  }
  
  // MARK: - Properties
  
  @IBOutlet weak var largePlayerContainer: UIView?
  
  var song: AppleMusicSong?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureDefaultBackButton()
    self.configureSmallNavigationTitle()
    
    switch self.presentedMode {
    case .navStack: break
    default:
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonSelected))
    }
  }
  
  // MARK: - Status Bar
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    switch self.presentedMode {
    case .custom(.appleMusic): return .lightContent
    default: return .default
    }
  }
  
  // MARK: - Actions
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let viewController = segue.destination as? AppleMusicNowPlayingLargePlayerViewController {
      viewController.presentedMode = self.presentedMode
      viewController.song = self.song
    }
  }
  
  @objc
  func doneButtonSelected() {
    self.dismissController()
  }
}
