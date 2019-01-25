//
//  AppleMusicNowPlayingBaseViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/23/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

class AppleMusicNowPlayingBaseViewController : BaseTableViewController, DataSourceProvider {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> AppleMusicNowPlayingBaseViewController {
    return self.newViewController(fromStoryboardWithName: "AppleMusicNowPlaying")
  }
  
  // MARK: - Properties
  
  let musicLibary = AppleMusicLibrary()
  var currentContent: Content?
  var cachedCoverImages: [UUID : ImageDownloadState] = [:]
  
  enum ImageDownloadState {
    case unattempted
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
    DispatchQueue.global(qos: .background).async {
      
      guard let url = song.coverArtURL, let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) else {
        DispatchQueue.main.async { [weak self] in
          self?.cachedCoverImages[song.id] = .failed
          self?.generateContent { [weak self] content in
            self?.currentContent = content
            self?.tableView.reloadRows(at: [ indexPath ], with: .none)
          }
        }
        return
      }
      
      DispatchQueue.main.async { [weak self] in
        self?.cachedCoverImages[song.id] = .downloaded(image: image)
        self?.generateContent { [weak self] content in
          self?.currentContent = content
          self?.tableView.reloadRows(at: [ indexPath ], with: .none)
        }
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
    self.configureLargeTitleBasedOnPresentedMode()
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
      case .unattempted:
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
  }
}

class AppleMusicLibraryCell : UITableViewCell, ClassNamable {
  @IBOutlet weak var albumArtImageView: UIImageView!
  @IBOutlet weak var songNameLabel: UILabel!
  @IBOutlet weak var artistAlbumLabel: UILabel!
}

class AppleMusicNowPlayingMiniPlayerViewController : BaseViewController {
  
}

class AppleMusicNowPlayingControlViewController : BaseViewController {
  
}
