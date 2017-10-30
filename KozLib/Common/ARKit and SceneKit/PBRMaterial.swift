//
//  PBRMaterial.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import Foundation
import SceneKit

struct PBRMaterial {
  
  private static var materials: [MaterialType : SCNMaterial] = [:]
  
  static func fetch(_ materialType: MaterialType) -> SCNMaterial {
    
    if let material = self.materials[materialType] {
      return material.copy() as! SCNMaterial
    }
    
    if materialType == .tron {
      let material = SCNMaterial.tron
      self.materials[materialType] = material
      return material.copy() as! SCNMaterial
      
    }
    
    if materialType == .transparent {
      let material = SCNMaterial.transparent
      self.materials[materialType] = material
      return material.copy() as! SCNMaterial
    }
    
    let material = SCNMaterial()
    material.lightingModel = .physicallyBased
    material.diffuse.contents = UIImage(named: "./Assets.scnassets/Materials/\(materialType.rawValue)/\(materialType.rawValue)-albedo.png")
    material.roughness.contents = UIImage(named: "./Assets.scnassets/Materials/\(materialType.rawValue)/\(materialType.rawValue)-roughness.png")
    material.metalness.contents = UIImage(named: "./Assets.scnassets/Materials/\(materialType.rawValue)/\(materialType.rawValue)-metal.png")
    material.normal.contents = UIImage(named: "./Assets.scnassets/Materials/\(materialType.rawValue)/\(materialType.rawValue)-normal.png")
    material.diffuse.wrapS = .repeat
    material.diffuse.wrapT = .repeat
    material.roughness.wrapS = .repeat
    material.roughness.wrapT = .repeat
    material.metalness.wrapS = .repeat
    material.metalness.wrapT = .repeat
    material.normal.wrapS = .repeat
    material.normal.wrapT = .repeat
    
    self.materials[materialType] = material
    return material.copy() as! SCNMaterial
  }
}
