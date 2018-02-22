//
//  Cube.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import Foundation
import SceneKit

class Cube : SCNNode {
  
  var materialType: MaterialType {
    didSet {
      self.childNodes.first?.geometry?.materials = [ PBRMaterial.fetch(self.materialType) ]
    }
  }
  
  init(position: SCNVector3, materialType: MaterialType) {
    self.materialType = materialType
    super.init()
    
    let dimension: CGFloat = 0.2
    let cube = SCNBox(width: dimension, height: dimension, length: dimension, chamferRadius: 0)
    cube.materials = [ PBRMaterial.fetch(materialType) ]
    let node = SCNNode(geometry: cube)
    
    // The physicsBody tells SceneKit this geometry should be manipulated by the physics engine
    node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
    node.physicsBody?.mass = 2
    node.physicsBody?.categoryBitMask = CollisionCategory.cube.rawValue
    node.position = position
    
    self.addChildNode(node)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func changeMaterial() {
    self.materialType = self.materialType.nextCubeMaterial
  }
}
