//
//  AppleMusicNowPlayingControlViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/26/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

class AppleMusicNowPlayingControlViewController : BaseTableViewController, DataSourceProvider {
  
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
  
  @IBOutlet weak var coverArtImageView: UIImageView!
  
  // MARK: - Properties
  
  internal var currentContent: Content?
  internal var currentContentDispatchQueue: DispatchQueue = DispatchQueue(label: "AppleMusicNowPlayingControlViewController.currentContentDispatchQueue")
  
  // MARK: - Properties
  
  var song: AppleMusicSong!
  var coverArtImage: UIImage?
  weak var delegate: AppleMusicNowPlayingMiniPlayerDelegate?
  
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
    
    self.updateContent()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.updateContent()
  }
  
  // MARK: - Status Bar
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    switch self.presentedMode {
    default:
      return .default
    }
  }
  
  // MARK: - Content
  
  struct Content : DataSourceContent {
    let sectionTypes: [SectionType]
  }
  
  func generateContent(completion: @escaping (_ content: Content) -> Void) {
    
    // Required properties
    let song = self.song!
    let coverArtImage = self.coverArtImage
    let currentContentDispatchQueue = self.currentContentDispatchQueue
    
    DispatchQueue.global().async {
      
      // Build the content
      var rowTypes: [RowType] = []
      
      rowTypes.append(.coverArt(coverArtImage))
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
    case songInformation(song: AppleMusicSong)
    case songControls
    case volume
    case songActions
    case scrollSpacer
    case shuffleRepeat
  }
}

// MARK: - Actions

extension AppleMusicNowPlayingControlViewController {
  
  @objc
  func doneButtonSelected() {
    self.dismissController()
  }
}

// MARK: - UITableView

extension AppleMusicNowPlayingControlViewController {
  
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
    
    let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
    switch rowType {
    case .coverArt:
      return 0.4 * safeAreaHeight
    case .songProgressBar:
      return 0.1 * safeAreaHeight
    case .songInformation:
      return 0.15 * safeAreaHeight
    case .songControls:
      return 0.15 * safeAreaHeight
    case .volume:
      return 0.1 * safeAreaHeight
    case .songActions:
      return 0.1 * safeAreaHeight
      
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
    case .scrollSpacer:
      let cell = UITableViewCell()
      cell.contentView.backgroundColor = .cyan
      return cell
      
    case .shuffleRepeat:
      let cell = UITableViewCell()
      cell.contentView.backgroundColor = .red
      return cell
      
    default:
      let cell = UITableViewCell()
      cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? .lightGray : .darkGray
      return cell
    }
  }
}
