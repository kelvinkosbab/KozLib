//
//  Mask.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import ARKit
import SceneKit

class Mask: SCNNode, VirtualFaceContent {
  
  init(geometry: ARSCNFaceGeometry) {
    let material = geometry.firstMaterial!
    
    material.diffuse.contents = UIColor.lightGray
    material.lightingModel = .physicallyBased
    
    super.init()
    self.geometry = geometry
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("\(#function) has not been implemented")
  }
  
  // MARK: VirtualFaceContent
  
  /// - Tag: SCNFaceGeometryUpdate
  func update(withFaceAnchor anchor: ARFaceAnchor) {
    let faceGeometry = geometry as! ARSCNFaceGeometry
    faceGeometry.update(from: anchor.geometry)
  }
}
