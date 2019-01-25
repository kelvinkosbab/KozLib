//
//  ARWallDetectionViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/1/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARWallDetectionViewController : BaseViewController, ConfigurationViewPresentable, DismissInteractable {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> ARWallDetectionViewController {
    return self.newViewController(fromStoryboardWithName: "ARKit")
  }
  
  // MARK: - DismissInteractable
  
  var dismissInteractiveViews: [UIView] {
    if let view = self.view {
      return [ view ]
    }
    return []
  }
  
  // MARK: - Properties
  
  @IBOutlet weak var sceneView: ARSCNView!
  
  private var sceneNode: SCNNode? = nil
  private var planes: [ARPlaneAnchor : BoxPlane] = [:]
  
  private let session = ARSession()
  private let sessionConfig = ARWorldTrackingConfiguration()
  
  // MARK: - AR Scene Properties
  
  private var currentCameraTrackingState: ARCamera.TrackingState? = nil {
    didSet {
      
      // Check if the device supports ARKit
      if let state = self.state {
        switch state {
        case .unsupported:
          return
        default: break
        }
      }
      
      guard let currentCameraTrackingState = self.currentCameraTrackingState else {
        self.state = .configuring
        return
      }
      
      switch currentCameraTrackingState {
      case .limited(.insufficientFeatures):
        self.state = .limited(.insufficientFeatures)
      case .limited(.excessiveMotion):
        self.state = .limited(.excessiveMotion)
      case .limited(.initializing):
        self.state = .limited(.initializing)
      case .limited(.relocalizing):
        self.state = .limited(.relocalizing)
      case .normal:
        self.state = .normal
      case .notAvailable:
        self.state = .notAvailable
      default:
        self.state = .normal
      }
    }
  }
  
  var state: ARState? = nil {
    didSet {
      self.arStateDidUpdate(self.state ?? .configuring)
    }
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Wall Detection"
    self.navigationItem.largeTitleDisplayMode = .never
    self.baseNavigationController?.navigationBarStyle = .transparent
    
    self.configureDefaultBackButton()
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.stopButtonSelected))
    
    // Setup the scene
    self.sceneView.setUp(delegate: self, session: self.session)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.baseNavigationController?.navigationBarStyle = .transparent
    
    // Set idle timer flag
    UIApplication.shared.isIdleTimerDisabled = true
    
    // Start / restart plane detection
    self.restartPlaneDetection()
    
    // Check camera tracking state
    self.arStateDidUpdate(self.state ?? .configuring)
    
    // Notifications
    NotificationCenter.default.addObserver(self, selector: #selector(self.restartPlaneDetection), name: UIApplication.didBecomeActiveNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.pauseScene), name: UIApplication.willResignActiveNotification, object: nil)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    // Reset idle timer flat
    UIApplication.shared.isIdleTimerDisabled = false
    
    // Pause the AR scene
    self.pauseScene()
    
    // Check camera tracking state
    self.arStateDidUpdate(self.state ?? .configuring)
    
    // Remove self from notifications
    NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: .locationManagerDidUpdateCurrentLocation, object: nil)
    NotificationCenter.default.removeObserver(self, name: .locationManagerDidUpdateCurrentHeading, object: nil)
  }
  
  // MARK: - Status Bar
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Actions
  
  @objc func stopButtonSelected() {
    self.dismissController()
  }
  
  // MARK: - AR State
  
  func arStateDidUpdate(_ state: ARState) {
    
    // Check if the scene hasn't already been configured
    guard self.sceneNode == nil else {
      // TODO: - KAK future - display any necessary state messages
      return
    }
    
    switch state {
    case .normal:
      self.hideConfiguringView()
    default:
      self.showConfiguringView(.statusMessage(state.status, state.message))
    }
  }
  
  // MARK: - Scene
  
  @objc func pauseScene() {
    self.session.pause()
  }
  
  @objc func restartPlaneDetection() {
    
    // Remove all nodes
    self.sceneNode?.removeFromParentNode()
    self.sceneNode = nil
    self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
      node.removeFromParentNode()
    }
    
    // Configure session
    self.sessionConfig.planeDetection = .horizontal
    self.sessionConfig.isLightEstimationEnabled = true
    self.sessionConfig.worldAlignment = .gravityAndHeading
    self.session.run(self.sessionConfig, options: [.resetTracking, .removeExistingAnchors])
  }
}

// MARK: - ARSCNViewDelegate

extension ARWallDetectionViewController : ARSCNViewDelegate {
  
  func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
    
    // Set the root scene node if the camera tracking state is normal
    if self.sceneNode == nil, let cameraTrackingState = self.currentCameraTrackingState {
      switch cameraTrackingState {
      case .normal:
        let sceneNode = SCNNode()
        self.sceneNode = sceneNode
        scene.rootNode.addChildNode(sceneNode)
        
      default: break
      }
    }
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
    Log.extendedLog("Session was interrupted")
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
    Log.extendedLog("Session interruption ended")
  }
  
  func session(_ session: ARSession, didFailWithError error: Error) {
    Log.extendedLog("Session did fail with error: \(error)")
    self.state = .unsupported(.ar)
  }
  
  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    self.currentCameraTrackingState = camera.trackingState
    switch camera.trackingState {
    case .limited(.insufficientFeatures):
      Log.extendedLog("Camera did change tracking state: limited, insufficient features")
    case .limited(.excessiveMotion):
      Log.extendedLog("Camera did change tracking state: limited, excessive motion")
    case .limited(.initializing):
      Log.extendedLog("Camera did change tracking state: limited, initializing")
    case .limited(.relocalizing):
      Log.extendedLog("Camera did change tracking state: limited, relocalizing")
    case .normal:
      Log.extendedLog("Camera did change tracking state: normal")
    case .notAvailable:
      Log.extendedLog("Camera did change tracking state: not available")
    default:
      Log.extendedLog("Unhandled Tracking State")
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    
    guard let anchor = anchor as? ARPlaneAnchor else {
      return
    }
    
    // When a new plane is detected we create a new SceneKit plane to visualize it in 3D
    let plane = BoxPlane.createPlane(.vertical, anchor: anchor)
    self.planes[anchor] = plane
    node.addChildNode(plane)
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    
    guard let anchor = anchor as? ARPlaneAnchor, let plane = self.planes[anchor] else {
      return
    }
    
    // When an anchor is updated we need to also update our 3D geometry too. For example the width and height of the plane detection may have changed so we need to update our SceneKit geometry to match that
    plane.update(anchor: anchor)
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    
    guard let anchor = anchor as? ARPlaneAnchor else {
      return
    }
    
    // Nodes will be removed if planes multiple individual planes that are detected to all be part of a larger plane are merged.
    self.planes.removeValue(forKey: anchor)
  }
}
