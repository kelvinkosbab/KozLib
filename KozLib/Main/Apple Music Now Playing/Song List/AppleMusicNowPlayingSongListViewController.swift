//
//  AppleMusicNowPlayingSongListViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/23/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

protocol AppleMusicNowPlayingSelectSongDelegate : class {
  func didSelect(song: AppleMusicSong, coverArtImage: UIImage?)
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
  var cachedCoverImages: [UUID : ImageDownloadState] = [:]
  weak var delegate: AppleMusicNowPlayingSelectSongDelegate?
  
  enum ImageDownloadState {
    case unattempted
    case noImage
    case downloaded(image: UIImage)
    case failed
  }
  
  // MARK: - Content
  
  struct Content : DataSourceContent {
    let sectionTypes: [SectionType]
  }
  
  func generateContent(completion: @escaping (_ content: Content) -> Void) {
    let songs = self.musicLibary.songs
    let cachedCoverImages = self.cachedCoverImages
    DispatchQueue.global().async {
      
      // Build the content
      var lastIndexPath: IndexPath?
      let rowTypes: [RowType] = songs.map { song -> RowType in
        let indexPath: IndexPath = {
          if let indexPath = lastIndexPath {
            let newIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            lastIndexPath = newIndexPath
            return newIndexPath
          } else {
            let newIndexPath = IndexPath(row: 0, section: 0)
            lastIndexPath = newIndexPath
            return newIndexPath
          }
        }()
        let imageDownloadState = cachedCoverImages[song.id] ?? .unattempted
        switch imageDownloadState {
        case .unattempted:
          self.fetchAlbumArtwork(song: song, at: indexPath)
        default: break
        }
        return .item(song: song, imageDownloadState: imageDownloadState, at: indexPath)
      }
      
      // Return the content
      let content = Content(sectionTypes: [ SectionType(rowTypes: rowTypes) ])
      DispatchQueue.main.async {
        completion(content)
      }
    }
  }
  
  func updateContent() {
    self.generateContent { [weak self] content in
      self?.currentContent = content
      self?.tableView?.reloadData()
    }
  }
  
  func fetchAlbumArtwork(song: AppleMusicSong, at indexPath: IndexPath) {
    
    guard let url = song.coverArtURL else {
      self.cachedCoverImages[song.id] = .noImage
      self.generateContent { [weak self] content in
        self?.currentContent = content
        self?.tableView.reloadRows(at: [ indexPath ], with: .none)
      }
      return
    }
    
    UIImage.download(url: url) { [weak self] image in
      if let image = image {
        self?.cachedCoverImages[song.id] = .downloaded(image: image)
      } else {
        self?.cachedCoverImages[song.id] = .failed
      }
      self?.generateContent { [weak self] content in
        self?.currentContent = content
        self?.tableView.reloadRows(at: [ indexPath ], with: .none)
      }
    }
  }
  
  // MARK: - SectionType
  
  struct SectionType : DataSourceSectionType {
    let rowTypes: [RowType]
  }
  
  // MARK: - RowType
  
  enum RowType : DataSourceRowType {
    case item(song: AppleMusicSong, imageDownloadState: ImageDownloadState, at: IndexPath)
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Music Library"
    self.configureDefaultBackButton()
    self.configureLargeNavigationTitle()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.updateContent()
  }
  
  // MARK: - UITableView
  
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
    case .item(song: let song, imageDownloadState: let imageDownloadState, at: _):
      let cell = tableView.dequeueReusableCell(withIdentifier: AppleMusicLibraryCell.name, for: indexPath) as! AppleMusicLibraryCell
      switch imageDownloadState {
      case .unattempted, .noImage:
        cell.albumArtImageView.backgroundColor = .lightGray
      case .failed:
        cell.albumArtImageView.backgroundColor = .red
      case .downloaded(image: let image):
        cell.albumArtImageView.backgroundColor = .clear
        cell.albumArtImageView.image = image
      }
      cell.songNameLabel.text = song.title
      cell.artistAlbumLabel.text = song.artist
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    guard let rowType = self.getRowType(at: indexPath) else {
      return
    }
    
    switch rowType {
    case .item(song: let song, imageDownloadState: let imageDownloadState, at: _):
      switch imageDownloadState {
        case .downloaded(image: let image):
        self.delegate?.didSelect(song: song, coverArtImage: image)
      default:
        self.delegate?.didSelect(song: song, coverArtImage: nil)
      }
    }
  }
}
