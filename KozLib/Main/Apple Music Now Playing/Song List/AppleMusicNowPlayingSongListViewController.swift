//
//  AppleMusicNowPlayingSongListViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/23/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

protocol AppleMusicNowPlayingSelectSongDelegate : class {
  func didSelect(song: AppleMusicSong)
}

class AppleMusicNowPlayingSongListViewController : BaseTableViewController, DataSourceProvider {
  
  // MARK: - Static Accessors
  
  private static func newViewController() -> AppleMusicNowPlayingSongListViewController {
    return self.newViewController(fromStoryboardWithName: "AppleMusicNowPlaying")
  }
  
  static func newViewController(delegate: AppleMusicNowPlayingSelectSongDelegate) -> AppleMusicNowPlayingSongListViewController {
    let viewController = self.newViewController()
    viewController.delegate = delegate
    return viewController
  }
  
  // MARK: - Properties
  
  let musicLibary = AppleMusicLibrary()
  var currentContent: Content?
  internal let currentContentDispatchQueue = DispatchQueue(label: "KosLibrary.AppleMusicNowPlayingSongListViewController.currentContentDispatchQueue")
  weak var delegate: AppleMusicNowPlayingSelectSongDelegate?
  
  // MARK: - Content
  
  struct Content : DataSourceContent {
    let sectionTypes: [SectionType]
  }
  
  func generateContent(completion: @escaping (_ content: Content) -> Void) {
    
    // Required properties
    let songs = self.musicLibary.songs
    let currentContentDispatchQueue = self.currentContentDispatchQueue
    
    DispatchQueue.global().async {
      
      // Build the content
      let rowTypes: [RowType] = songs.map { song -> RowType in return .item(song: song) }
      
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
    self.generateContent { [weak self] content in
      self?.tableView?.reloadData()
    }
  }
  
  // MARK: - SectionType
  
  struct SectionType : DataSourceSectionType {
    let rowTypes: [RowType]
  }
  
  // MARK: - RowType
  
  enum RowType : DataSourceRowType {
    case item(song: AppleMusicSong)
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Music Library"
    self.configureDefaultBackButton()
    self.configureLargeNavigationTitle()
    
    self.tableView.contentInset = UIEdgeInsets(top: self.tableView.contentInset.top, left: self.tableView.contentInset.left, bottom: self.tableView.contentInset.bottom + 60, right: self.tableView.contentInset.right)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.updateContent()
  }
}

// MARK: - UITableView

extension AppleMusicNowPlayingSongListViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return self.numberOfSections
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.getNumberOfItems(section: section)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let rowType = self.getRowType(at: indexPath) else {
      return UITableViewCell()
    }
    
    switch rowType {
    case .item(song: let song):
      let cell = tableView.dequeueReusableCell(withIdentifier: AppleMusicLibraryCell.name, for: indexPath) as! AppleMusicLibraryCell
      if let imageName = song.imageName, let image = UIImage(named: imageName) {
        cell.albumArtImageView.backgroundColor = .clear
        cell.albumArtImageView.image = image
      } else {
        cell.albumArtImageView.backgroundColor = .lightGray
        cell.albumArtImageView.image = nil
      }
      cell.songNameLabel.text = song.title
      cell.artistAlbumLabel.text = "\(song.artist) - Album"
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    guard let rowType = self.getRowType(at: indexPath) else {
      return
    }
    
    switch rowType {
    case .item(song: let song):
      self.delegate?.didSelect(song: song)
    }
  }
}
