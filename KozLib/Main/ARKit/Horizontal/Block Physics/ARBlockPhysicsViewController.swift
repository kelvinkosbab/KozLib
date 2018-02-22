//
//  ARBlockPhysicsViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 10/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARBlockPhysicsViewController : ARPlaneMappingViewController {
  
  // MARK: - Properties
  
  var cubes: [Cube] = []
  var currentCubeMaterial: MaterialType = MaterialType.oakfloor2
  var currentPlaneMaterial: MaterialType = MaterialType.tron
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Block Physics"
    
    self.setupPhysics()
    self.setupGestureRecognizers()
  }
  
  // MARK: - Lights
  
  func setupLights() {
    
    // Turn off all the default lights SceneKit adds since we are handling it ourselves
    self.sceneView.autoenablesDefaultLighting = false
    self.sceneView.automaticallyUpdatesLighting = false
    self.sceneView.scene.lightingEnvironment.contents = #imageLiteral(resourceName: "spherical.jpg")
  }
  
  // MARK: - Physics
  
  func setupPhysics() {
    
    // For our physics interactions, we place a large node a couple of meters below the world origin, after an explosion, if the geometry we added has fallen onto this surface which is place way below all of the surfaces we would have detected via ARKit then we consider this geometry to have fallen out of the world and remove it
    let bottomPlane = SCNBox(width: 1000, height: 0.5, length: 1000, chamferRadius: 0)
    let bottomMaterial = SCNMaterial()
    bottomMaterial.diffuse.contents = UIColor(white: 1, alpha: 0)
    bottomPlane.materials = [ bottomMaterial ]
    
    // Configure the physics for the material
    let bottomNode = SCNNode(geometry: bottomPlane)
    bottomNode.position = SCNVector3(x: 0, y: -10, z: 0)
    bottomNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
    bottomNode.physicsBody?.categoryBitMask = CollisionCategory.bottom.rawValue
    bottomNode.physicsBody?.contactTestBitMask = CollisionCategory.cube.rawValue
    
    // Add the bottom plane to the scene
    self.sceneView.scene.rootNode.addChildNode(bottomNode)
    self.sceneView.scene.physicsWorld.contactDelegate = self
  }
  
  // MARK: - Gestures
  
  func setupGestureRecognizers() {
    
    // Single tap will insert a new piece of geometry into the scene
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    tapGestureRecognizer.numberOfTapsRequired = 1
    self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    
    // Press and hold will cause an explosion causing geometry in the local vicinity of the explosion to move
    let explosionGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleHold(_:)))
    explosionGestureRecognizer.minimumPressDuration = 0.5
    self.sceneView.addGestureRecognizer(explosionGestureRecognizer)
    
    let hidePlanesGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleHidePlane(_:)))
    hidePlanesGestureRecognizer.minimumPressDuration = 1
    hidePlanesGestureRecognizer.numberOfTouchesRequired = 2
    self.sceneView.addGestureRecognizer(explosionGestureRecognizer)
  }
  
  @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
    
    // Take the screen space tap coordinates and pass them to the hitTest method on the ARSCNView instance
    let tapPoint = recognizer.location(in: self.sceneView)
    let result = self.sceneView.hitTest(tapPoint, types: .existingPlaneUsingExtent)
    
    // If the intersection ray passes through any plane geometry they will be returned, with the planes ordered by distance from the camera
    guard result.count > 0, let hitResult = result.first else {
      return
    }
    
    // If there are multiple hits, just pick the closest plane
    self.insertCube(at: hitResult)
  }
  
  @objc func handleHold(_ recognizer: UILongPressGestureRecognizer) {
    
    guard recognizer.state == .began else {
      return
    }
    
    // Perform a hit test using the screen coordinates to see if the user pressed on a plane.
    let holdPoint = recognizer.location(in: self.sceneView)
    let result = self.sceneView.hitTest(holdPoint, types: .existingPlaneUsingExtent)
    guard result.count > 0, let hitResult = result.first else {
      return
    }
    
    DispatchQueue.main.async {
      self.explode(at: hitResult)
    }
  }
  
  @objc func handleHidePlane(_ recognizer: UILongPressGestureRecognizer) {
    
    guard recognizer.state == .began else {
      return
    }
    
    // Hide all the planes
    for (_, plane) in self.planes {
      plane.hide()
    }
    
    // Stop detecting new planes or updating existing ones.
    if let configuration = self.sceneView.session.configuration as? ARWorldTrackingConfiguration {
      configuration.planeDetection = .none
      self.sceneView.session.run(configuration, options: [])
    }
  }
  
  func explode(at hitResult: ARHitTestResult) {
    
    // For an explosion, we take the world position of the explosion and the position of each piece of geometry in the world. We then take the distance between those two points, the closer to the explosion point the geometry is the stronger the force of the explosion.
    
    // The hitResult will be a point on the plane, we move the explosion down a little bit below the plane so that the goemetry fly upwards off the plane
    let explosionYOffset: Float = 0.1
    let position = SCNVector3(x: hitResult.worldTransform.columns.3.x,
                              y: hitResult.worldTransform.columns.3.y - explosionYOffset,
                              z: hitResult.worldTransform.columns.3.z)
    
    // We need to find all of the geometry affected by the explosion, ideally we would have some spatial data structure like an octree to efficiently find all geometry close to the explosion but since we don't have many items, we can just loop through all of the current geoemtry
    for cubeNode in self.cubes {
      
      // The distance between the explosion and the geometry
      var distance = SCNVector3(x: cubeNode.worldPosition.x - position.x,
                                y: cubeNode.worldPosition.y - position.y,
                                z: cubeNode.worldPosition.z - position.z)
      let len = sqrtf(powf(distance.x, 2) + powf(distance.y, 2) + powf(distance.z, 2))
      
      // Set the maximum distance that the explosion will be felt, anything further than 2 meters from the explosion will not be affected by any forces
      let maxDistance: Float = 2
      var scale = max(0, maxDistance - len)
      
      // Scale the force of the explosion
      scale = scale * scale * 2
      
      // Scale the distance vector to the appropriate scale
      distance.x = distance.x / len * scale
      distance.y = distance.y / len * scale
      distance.z = distance.z / len * scale
      
      // Apply a force to the geometry. We apply the force at one of the corners of the cube to make it spin more, vs just at the center
      cubeNode.physicsBody?.applyForce(SCNVector3(x: 0.05, y: 0.05, z: 0.05), asImpulse: true)
    }
  }
  
  func insertCube(at hitResult: ARHitTestResult) {
    
    // We insert the geometry slightly above the point the user tapped, so that it drops onto the plane using the physics engine
    let insertionYOffset: Float = 0.5
    let position = SCNVector3(x: hitResult.worldTransform.columns.3.x,
               y: hitResult.worldTransform.columns.3.y + insertionYOffset,
               z: hitResult.worldTransform.columns.3.z)
    
    let cube = Cube(position: position, materialType: self.currentCubeMaterial)
    self.cubes.append(cube)
    self.sceneView.scene.rootNode.addChildNode(cube)
  }
  
  override func sessionInterruptionEnded(_ session: ARSession) {
    super.sessionInterruptionEnded(session)
    
    self.reset()
  }
  
  func reset() {
    for (_, plane) in self.planes {
      plane.removeFromParentNode()
    }
    for cube in self.cubes {
      cube.removeFromParentNode()
    }
    self.sceneView.session.run(self.sessionConfig, options: [ .resetTracking, .removeExistingAnchors ])
  }
}

extension ARBlockPhysicsViewController : SCNPhysicsContactDelegate {
  
  func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
    
    // Here we detect a collision between pieces of geometry in the world, if one of the pieces of geometry is the bottom plane it means the geometry has fallen out of the world. just remove it
    guard let nodeAPhysicsBody = contact.nodeA.physicsBody,
      let nodeBPhysicsBody = contact.nodeB.physicsBody,
      let nodeACategory = CollisionCategory(rawValue: nodeAPhysicsBody.categoryBitMask),
      let nodeBCategory = CollisionCategory(rawValue: nodeBPhysicsBody.categoryBitMask) else {
      return
    }
    
    if (nodeACategory == .bottom && nodeBCategory == .cube) || (nodeACategory == .cube && nodeBCategory == .bottom) {
      if nodeACategory == .bottom {
        contact.nodeB.removeFromParentNode()
      } else {
        contact.nodeA.removeFromParentNode()
      }
    }
  }
}
