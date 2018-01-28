//
//  DragonNode.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import SceneKit

class DragonNode : VirtualObject {
  
  // MARK: - Required
  
  override var modelName: String {
    return "DragonNode"
  }
  
  override var fileExtension: String {
    return "dae"
  }
  
  override var subdirectory: String {
    return "Dragon/"
  }
  
  // MARK: - Load
  
  override func loadModel(completion: @escaping () -> Void) {
    super.loadModel { [weak self] in
      
      // Size this node to a 1m bounding box
      self?.baseWrapperNode?.set(desiredSizeDimension: 0.7)
      
      completion()
    }
  }
}
