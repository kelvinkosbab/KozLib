//
//  SCNMaterial+Util.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import Foundation
import SceneKit

extension SCNMaterial {
  
  static var tron: SCNMaterial {
    let material = SCNMaterial()
    material.diffuse.contents = #imageLiteral(resourceName: "tron_grid")
    return material
  }
  
  static var transparent: SCNMaterial {
    let material = SCNMaterial()
    material.diffuse.contents = UIColor(white: 1, alpha: 0)
    return material
  }
}
