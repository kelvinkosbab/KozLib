//
//  ARPlaneMappingViewController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARPlaneMappingViewController : ARBaseViewController {
  
  // MARK: - Properties
  
  var planes: [UUID : Plane] = [:]
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Plane Visualization"
    self.navigationItem.largeTitleDisplayMode = .never
    self.baseNavigationController?.navigationBarStyle = .transparent
    
    self.configureDefaultBackButton()
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.stopButtonSelected))
  }
  
  // MARK: - Actions
  
  @objc func stopButtonSelected() {
    self.dismissController()
  }
}

// MARK: - ARSCNViewDelegate

extension ARPlaneMappingViewController {
  
  override func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    super.renderer(renderer, didAdd: node, for: anchor)
    
    guard let anchor = anchor as? ARPlaneAnchor else {
      return
    }
    
    // When a new plane is detected we create a new SceneKit plane to visualize it in 3D
    let plane = Plane(anchor: anchor, isHidden: false)
    self.planes[anchor.identifier] = plane
    node.addChildNode(plane)
  }
  
  override func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    super.renderer(renderer, didUpdate: node, for: anchor)
    
    guard let plane = self.planes[anchor.identifier], let anchor = anchor as? ARPlaneAnchor else {
      return
    }
    
    // When an anchor is updated we need to also update our 3D geometry too. For example the width and height of the plane detection may have changed so we need to update our SceneKit geometry to match that
    plane.update(anchor: anchor)
  }
  
  override func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    super.renderer(renderer, didRemove: node, for: anchor)
    
    // Nodes will be removed if planes multiple individual planes that are detected to all be part of a larger plane are merged.
    self.planes.removeValue(forKey: anchor.identifier)
  }
}
