//
//  VirtualFaceContent.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 `VirtualFaceContent` provides an interface for the content in this sample to update in response to
 tracking changes.
 */

import ARKit
import SceneKit

protocol VirtualFaceContent {
  func update(withFaceAnchor: ARFaceAnchor)
}

typealias VirtualFaceNode = VirtualFaceContent & SCNNode

// MARK: Loading Content

func loadedContentForAsset(named resourceName: String) -> SCNNode {
  let url = Bundle.main.url(forResource: resourceName, withExtension: "scn", subdirectory: "Models.scnassets")!
  let node = SCNReferenceNode(url: url)!
  node.load()
  
  return node
}
