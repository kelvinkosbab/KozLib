//
//  SCNNode+Util.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import SceneKit

extension SCNNode {
  
  // Scales a node to a specific size dimension
  func set(desiredSizeDimension maxSize: Float) {
    let boundingBox = self.boundingBox.max - self.boundingBox.min
    let maxNodeBound = max(boundingBox.x, max(boundingBox.y, boundingBox.z))
    let scale = maxSize / maxNodeBound
    self.scale = SCNVector3(x: scale, y: scale, z: scale)
  }
}
