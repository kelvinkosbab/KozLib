//
//  HomeViewController+UITableView.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 8/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

extension HomeViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return self.dataSource.numberOfSections
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    guard let sectionType = self.dataSource.getSectionType(section: section) else {
      return nil
    }
    
    return sectionType.title
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.dataSource.getNumberOfItems(section: section)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let rowType = self.dataSource.getRowType(at: indexPath) else {
      let cell = UITableViewCell()
      cell.contentView.backgroundColor = tableView.backgroundColor
      return cell
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.name, for: indexPath) as! HomeTableViewCell
    cell.configure(title: rowType.title, accessoryType: .disclosureIndicator)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let rowType = self.dataSource.getRowType(at: indexPath) else {
      tableView.deselectRow(at: indexPath, animated: true)
      return
    }
    
    self.didSelect(rowType: rowType)
  }
}

// MARK: - UITableViewCells

class HomeTableViewCell : UITableViewCell, ClassNamable {
  
  @IBOutlet weak var titleLabel: UILabel!
  
  func configure(title: String?, accessoryType: UITableViewCellAccessoryType = .none) {
    self.titleLabel.text = title
    self.accessoryType = accessoryType
  }
}
