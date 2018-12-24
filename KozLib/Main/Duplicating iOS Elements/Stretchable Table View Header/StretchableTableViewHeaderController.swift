//
//  StretchableTableViewHeaderController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 12/23/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class StretchableTableViewHeaderController : BaseTableViewController {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> StretchableTableViewHeaderController {
    return self.newViewController(fromStoryboardWithName: "StretchableTableViewHeader")
  }
  
  // MARK: - View Properties
  
  private var didConfigureHeaderView: Bool = false
  private let headerViewHeight: CGFloat = 200
  
  internal var stretchableTableViewCell: StretchableTableViewCell?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure navigation bar
    self.title = "Stretchable Header"
    self.configureDefaultBackButton()
    self.configureLargeTitleBasedOnPresentedMode()
  }
  
  // MARK: - UIScrollViewDelegate
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < 0, let stretchableTableViewCell = self.stretchableTableViewCell {
      stretchableTableViewCell.heightConstraint?.constant = self.headerViewHeight - scrollView.contentOffset.y
      stretchableTableViewCell.topConstraint?.constant = scrollView.contentOffset.y
      stretchableTableViewCell.layoutIfNeeded()
      Log.log("KAK \(self.headerViewHeight - scrollView.contentOffset.y)")
    } else {
      self.stretchableTableViewCell?.heightConstraint?.constant = self.headerViewHeight
      self.stretchableTableViewCell?.topConstraint?.constant = 0
      self.stretchableTableViewCell?.layoutIfNeeded()
    }
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension StretchableTableViewHeaderController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    guard section == 0 else {
      return super.tableView(tableView, viewForHeaderInSection: section)
    }

    if let cell = self.stretchableTableViewCell {
      return cell.contentView
    }

    let cell = tableView.dequeueReusableCell(withIdentifier: StretchableTableViewCell.name) as! StretchableTableViewCell
    cell.stretchableImageView?.image = UIImage(named: "AppIcon_Wallpaper")
    cell.contentView.clipsToBounds = false
    cell.heightConstraint?.constant = self.headerViewHeight
    self.stretchableTableViewCell = cell
    return cell.contentView
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == 0 ? self.headerViewHeight : .leastNormalMagnitude
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 50
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.selectionStyle = .none
    cell.textLabel?.text = "Row \(indexPath.row)"
    return cell
  }
}

// MARK: - StretchableTableViewCell

class StretchableTableViewCell : UITableViewCell, ClassNamable {
  @IBOutlet weak var heightConstraint: NSLayoutConstraint?
  @IBOutlet weak var topConstraint: NSLayoutConstraint?
  @IBOutlet weak var stretchableImageView: UIImageView?
}
