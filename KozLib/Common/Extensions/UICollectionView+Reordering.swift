//
//  UICollectionView+Reordering.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

extension UICollectionView {
  
  // When embedding a collection view as a child view controller in a container view more configuration is necessary to get reordering to work properly. This should be called in segue or when programmatically adding this controller to another view controller
  
  func configureLongPressReordering() {
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleCollectionViewLongGesture(_:)))
    self.addGestureRecognizer(gesture)
  }
  
  @objc func handleCollectionViewLongGesture(_ gesture: UILongPressGestureRecognizer) {
    switch(gesture.state) {
    case .began:
      guard let selectedIndexPath = self.indexPathForItem(at: gesture.location(in: self)) else {
        break
      }
      self.beginInteractiveMovementForItem(at: selectedIndexPath)
      break
      
    case .changed:
      
      self.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
      break
      
    case .ended:
      self.endInteractiveMovement()
      break
      
    default:
      self.cancelInteractiveMovement()
      break
    }
  }
}

