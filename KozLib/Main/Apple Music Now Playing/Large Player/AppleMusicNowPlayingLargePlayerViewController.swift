//
//  AppleMusicNowPlayingLargePlayerViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/26/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

class AppleMusicNowPlayingLargePlayerViewController : BaseTableViewController, DataSourceProvider {
  
  // MARK: - Static Accessors
  
  private static func newViewController() -> AppleMusicNowPlayingLargePlayerViewController {
    return self.newViewController(fromStoryboardWithName: "AppleMusicNowPlaying")
  }
  
  static func newViewController(song: AppleMusicSong) -> AppleMusicNowPlayingLargePlayerViewController {
    let viewController = self.newViewController()
    viewController.song = song
    return viewController
  }
  
  // MARK: - Outlet Properties
  
  weak var coverArtImageView: UIImageView?
  
  // MARK: - Properties
  
  internal var currentContent: Content?
  internal var currentContentDispatchQueue: DispatchQueue = DispatchQueue(label: "AppleMusicNowPlayingControlViewController.currentContentDispatchQueue")
  
  // MARK: - Properties
  
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.updateContent()
  }
  
  // MARK: - Status Bar
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    switch self.presentedMode {
    case .custom(.appleMusic): return .lightContent
    default: return .default
    }
  }
  
  // MARK: - Content
  
  struct Content : DataSourceContent {
    let sectionTypes: [SectionType]
  }
  
  func generateContent(completion: @escaping (_ content: Content) -> Void) {
    
    // Required properties
    let song = self.song
    let currentContentDispatchQueue = self.currentContentDispatchQueue
    
    DispatchQueue.global().async {
      
      // Build the content
      var rowTypes: [RowType] = []
      
      if let imageName = song?.imageName, let image = UIImage(named: imageName) {
        rowTypes.append(.coverArt(image))
      } else {
        rowTypes.append(.coverArt(nil))
      }
      rowTypes.append(.songProgressBar(Progress(totalUnitCount: 1000)))
      rowTypes.append(.songInformation(song: song))
      rowTypes.append(.songControls)
      rowTypes.append(.volume)
      rowTypes.append(.songActions)
      
      rowTypes.append(.scrollSpacer)
      
      rowTypes.append(.shuffleRepeat)
      
      // Return the content
      let content = Content(sectionTypes: [ SectionType(rowTypes: rowTypes) ])
      currentContentDispatchQueue.sync { [weak self] in
        self?.currentContent = content
        DispatchQueue.main.async {
          completion(content)
        }
      }
    }
  }
  
  func updateContent() {
    self.generateContent { [weak self] _ in
      self?.tableView.reloadData()
    }
  }
  
  // MARK: - SectionType
  
  struct SectionType : DataSourceSectionType {
    let rowTypes: [RowType]
  }
  
  // MARK: - RowType
  
  enum RowType : DataSourceRowType {
    case coverArt(UIImage?)
    case songProgressBar(Progress)
    case songInformation(song: AppleMusicSong?)
    case songControls
    case volume
    case songActions
    case scrollSpacer
    case shuffleRepeat
  }
}

// MARK: - Actions

extension AppleMusicNowPlayingLargePlayerViewController {
  
  @objc
  func doneButtonSelected() {
    self.dismissController()
  }
}

// MARK: - UITableView

extension AppleMusicNowPlayingLargePlayerViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return self.numberOfSections
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.getNumberOfItems(section: section)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    guard let rowType = self.getRowType(at: indexPath) else {
      return .leastNormalMagnitude
    }
    
    let safeAreaFrame = self.view.safeAreaLayoutGuide.layoutFrame
    let coverArtHeight = safeAreaFrame.width - 16
    let safeAreaHeightMinusImage = safeAreaFrame.height - coverArtHeight
    switch rowType {
    case .coverArt:
      return coverArtHeight
      
    case .songProgressBar:
      return 0.1 * safeAreaHeightMinusImage
    case .songInformation:
      return 0.3 * safeAreaHeightMinusImage
    case .songControls:
      return 0.3 * safeAreaHeightMinusImage
    case .volume:
      return 0.15 * safeAreaHeightMinusImage
    case .songActions:
      return 0.15 * safeAreaHeightMinusImage
      
    case .scrollSpacer:
      let bottomSafeAreaInset = self.view.safeAreaInsets.bottom
      return bottomSafeAreaInset == 0 ? 20 : bottomSafeAreaInset
      
    case .shuffleRepeat:
      return 60
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let rowType = self.getRowType(at: indexPath) else {
      return UITableViewCell()
    }
    
    switch rowType {
    case .coverArt(let image):
      let cell = tableView.dequeueReusableCell(withIdentifier: AppleMusicNowPlayingLargePlayerCoverArtCell.name, for: indexPath) as! AppleMusicNowPlayingLargePlayerCoverArtCell
      cell.configure(coverArtImage: image, rowHeight: self.tableView(tableView, heightForRowAt: indexPath))
      self.coverArtImageView = cell.coverArtImageView
      return cell
      
    case .songProgressBar(let progress):
      let cell = tableView.dequeueReusableCell(withIdentifier: AppleMusicNowPlayingLargePlayerProgressCell.name, for: indexPath) as! AppleMusicNowPlayingLargePlayerProgressCell
      cell.progressBar.progress = Float(progress.fractionCompleted)
      return cell
      
    case .songInformation(song: let song):
      let cell = tableView.dequeueReusableCell(withIdentifier: AppleMusicNowPlayingLargePlayerSongInfoCell.name, for: indexPath) as! AppleMusicNowPlayingLargePlayerSongInfoCell
      if let song = song {
        cell.songNameLabel.text = song.title
        cell.songInfoLabel.text = "\(song.artist) - Album"
      } else {
        cell.songNameLabel.text = nil
        cell.songInfoLabel.text = nil
      }
      return cell
      
    case .songControls:
      let cell = tableView.dequeueReusableCell(withIdentifier: AppleMusicNowPlayingLargePlayerControlCell.name, for: indexPath) as! AppleMusicNowPlayingLargePlayerControlCell
      let skipBackwardImage = UIImage(named: "icSkipBackward")?.withRenderingMode(.alwaysTemplate)
      cell.previousButton.setImage(skipBackwardImage, for: .normal)
      cell.previousButton.tintColor = .black
      let playImage = UIImage(named: "icPlay")?.withRenderingMode(.alwaysTemplate)
      cell.playPauseButton.setImage(playImage, for: .normal)
      cell.playPauseButton.tintColor = .black
      let skipForwardImage = UIImage(named: "icSkipForward")?.withRenderingMode(.alwaysTemplate)
      cell.forwardButton.setImage(skipForwardImage, for: .normal)
      cell.forwardButton.tintColor = .black
      return cell
      
    case .volume:
      let cell = tableView.dequeueReusableCell(withIdentifier: AppleMusicNowPlayingLargePlayerVolumeCell.name, for: indexPath) as! AppleMusicNowPlayingLargePlayerVolumeCell
      return cell
      
    case .songActions:
      let cell = tableView.dequeueReusableCell(withIdentifier: AppleMusicNowPlayingLargePlayerActionsCell.name, for: indexPath) as! AppleMusicNowPlayingLargePlayerActionsCell
      let plusButton = UIImage(named: "icPlus")?.withRenderingMode(.alwaysTemplate)
      cell.plusButton.setImage(plusButton, for: .normal)
      cell.plusButton.tintColor = .red
      let airplayImage = UIImage(named: "icAirplay")?.withRenderingMode(.alwaysTemplate)
      cell.airplayButton.setImage(airplayImage, for: .normal)
      cell.airplayButton.tintColor = .red
      let moreImage = UIImage(named: "icMore")?.withRenderingMode(.alwaysTemplate)
      cell.moreButton.setImage(moreImage, for: .normal)
      cell.moreButton.tintColor = .red
      return cell
      
    case .scrollSpacer:
      let cell = UITableViewCell()
      cell.contentView.backgroundColor = tableView.backgroundColor
      return cell
      
    case .shuffleRepeat:
      let cell = tableView.dequeueReusableCell(withIdentifier: AppleMusicNowPlayingLargePlayerShuffleRepeatCell.name, for: indexPath) as! AppleMusicNowPlayingLargePlayerShuffleRepeatCell
      cell.shuffleButton.setTitle("Shuffle", for: .normal)
      cell.shuffleButton.setTitleColor(.red, for: .normal)
      cell.shuffleButton.backgroundColor = UIColor(hex: "F2F2F2")
      cell.repeatButton.setTitle("Repeat", for: .normal)
      cell.repeatButton.setTitleColor(.red, for: .normal)
      cell.repeatButton.backgroundColor = UIColor(hex: "F2F2F2")
      return cell
    }
  }
}

// MARK: - MaxiPlayerSourceProtocol

extension AppleMusicNowPlayingLargePlayerViewController : AppleMusicLargePlayerSourceProtocol {
  
  var originatingFrameInWindow: CGRect {
    return self.view.convert(self.view.frame, to: nil)
  }
  
  var originatingCoverImageView: UIImageView? {
    return self.coverArtImageView
  }
}
