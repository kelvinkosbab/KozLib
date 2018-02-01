//
//  Plane.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import SceneKit
import ARKit

class BoxPlane : SCNNode {
  
  // MARK: - Static Accessors
  
  static func createPlane(_ planeType: PlaneType, anchor: ARPlaneAnchor, materialType: MaterialType = .tron) -> BoxPlane {
    switch planeType {
    case .horizontal:
      return HorizontalBoxPlane(anchor: anchor, materialType: materialType)
    case .vertical:
      return VerticalBoxPlane(anchor: anchor, materialType: materialType)
    }
  }
  
  // MARK: - Properties
  
  enum PlaneType {
    case horizontal, vertical
  }
  
  let anchor: ARPlaneAnchor
  let planeGeometry: SCNBox
  
  var materialType: MaterialType {
    didSet {
      self.didSetMaterialType()
    }
  }
  
  // MARK - Init
  
  init(anchor: ARPlaneAnchor, planeGeometry: SCNBox, materialType: MaterialType) {
    self.anchor = anchor
    self.planeGeometry = planeGeometry
    self.materialType = materialType
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Final Methods
  
  final func hide() {
    let transparentMaterial = SCNMaterial()
    transparentMaterial.diffuse.contents = UIColor(white: 1, alpha: 0)
    self.planeGeometry.materials = [ transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial ]
  }
  
  final func changeMaterial() {
    self.materialType = self.materialType.nextPlaneMaterial
  }
  
  // MARK: - Overridable Methods
  
  func update(anchor: ARPlaneAnchor) {}
  
  func didSetMaterialType() {}
}
