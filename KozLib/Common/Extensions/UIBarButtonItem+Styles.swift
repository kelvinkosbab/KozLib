//
//  UIBarButtonItem+Styles.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/21/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
  
  // MARK: - Style
  
  enum CustomStyle {
    case plain(UIColor)
    case done(UIColor)
    
    var font: UIFont {
      switch self {
      case .plain:
        return UIFont.systemFont(ofSize: 15, weight: .regular)
      case .done:
        return UIFont.systemFont(ofSize: 15, weight: .bold)
      }
    }
    
    var textColor: UIColor {
      switch self {
      case .plain(let color), .done(let color):
        return color
      }
    }
    
    var textAttributes: [NSAttributedString.Key : Any] {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.minimumLineHeight = 20
      return [ NSAttributedString.Key.font : self.font,
               NSAttributedString.Key.foregroundColor : self.textColor,
               NSAttributedString.Key.paragraphStyle : paragraphStyle ]
    }
  }
}

extension UIBarButtonItem {
  
  // MARK: - Custom Buttons
  
  convenience init(text title: String, style: UIBarButtonItem.CustomStyle = .plain(.blue), target: Any?, action: Selector?) {
    self.init(title: title, style: .plain, target: target, action: action)
    self.set(style: style)
  }
  
  // MARK: - UIBarButtonItem Styles
  
  private func set(style: UIBarButtonItem.CustomStyle) {
    self.setTitleTextAttributes(style.textAttributes, for: .normal)
  }
}
