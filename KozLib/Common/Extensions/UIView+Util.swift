//
//  UIView+Util.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

extension UIView {
  
  func addToContainer(_ containerView: UIView, atIndex index: Int? = nil, topMargin: CGFloat = 0, bottomMargin: CGFloat = 0, leadingMargin: CGFloat = 0, trailingMargin: CGFloat = 0) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.frame = containerView.frame
    
    if let index = index {
      containerView.insertSubview(self, at: index)
    } else {
      containerView.addSubview(self)
    }
    
    let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: topMargin)
    let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: bottomMargin)
    let leading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: leadingMargin)
    let trailing = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: trailingMargin)
    containerView.addConstraints([ top, bottom, leading, trailing ])
    containerView.layoutIfNeeded()
  }
}

