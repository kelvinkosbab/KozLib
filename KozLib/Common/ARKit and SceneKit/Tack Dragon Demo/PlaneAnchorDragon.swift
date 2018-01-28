//
//  PlaneAnchorDragon.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import ARKit

class PlaneAnchorDragon : Hashable {
  
  // MARK: - Properties and Init
  
  weak var planeAnchor: ARPlaneAnchor? = nil
  weak var dragonNode: DragonNode? = nil
  
  init(planeAnchor: ARPlaneAnchor, dragonNode: DragonNode) {
    self.planeAnchor = planeAnchor
    self.dragonNode = dragonNode
  }
  
  // MARK: - Hashable
  
  var hashValue: Int {
    if let planeAnchor = self.planeAnchor {
      return planeAnchor.hashValue
    }
    return -1
  }
  
  // MARK: - Equatable
  
  static func ==(lhs: PlaneAnchorDragon, rhs: PlaneAnchorDragon) -> Bool {
    return lhs.planeAnchor == rhs.planeAnchor
  }
}
