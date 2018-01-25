//
//  ARBaseViewController.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARBaseViewController : BaseViewController, NewViewControllerProtocol {
  
  // MARK: - NewViewControllerProtocol
  
  static let storyboardName: String = "ARKit"
  
  // MARK: - Properties
  
  @IBOutlet weak var sceneView: ARSCNView!
  
  var screenCenter: CGPoint? = nil
  
  let session = ARSession()
  var sessionConfig = ARWorldTrackingConfiguration()
  
  var trackingFallbackTimer: Timer?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupScene()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.baseNavigationController?.navigationBarStyle = .transparent
    
    UIApplication.shared.isIdleTimerDisabled = true
    self.restartPlaneDetection()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    self.session.pause()
  }
  
  // MARK: - Status Bar
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Scene
  
  func setupScene() {
    self.sceneView.setUp(delegate: self, session: self.session)
    DispatchQueue.main.async {
      self.screenCenter = self.sceneView.bounds.mid
    }
  }
}

// MARK: - ARSCNView

extension ARBaseViewController : ARSCNViewDelegate {
  
  func restartPlaneDetection() {
    
    // Configure session
    self.sessionConfig.planeDetection = .horizontal
    self.sessionConfig.isLightEstimationEnabled = true
    self.session.run(self.sessionConfig, options: [.resetTracking, .removeExistingAnchors])
    
    // Reset timer
    if self.trackingFallbackTimer != nil {
      self.trackingFallbackTimer!.invalidate()
      self.trackingFallbackTimer = nil
    }
  }
  
  /*
   Called when a new node has been mapped to the given anchor.
   
   @param renderer The renderer that will render the scene.
   @param node The node that maps to the anchor.
   @param anchor The added anchor.
   */
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {}
  
  /*
   Called when a node has been updated with data from the given anchor.
   
   @param renderer The renderer that will render the scene.
   @param node The node that was updated.
   @param anchor The anchor that was updated.
   */
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {}
  
  /*
   Called when a mapped node has been removed from the scene graph for the given anchor.
   
   @param renderer The renderer that will render the scene.
   @param node The node that was removed.
   @param anchor The anchor that was removed.
   */
  func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {}
  
  /*
   Called when a node will be updated with data from the given anchor.
   
   @param renderer The renderer that will render the scene.
   @param node The node that will be updated.
   @param anchor The anchor that was updated.
   */
  func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {}
  
  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {}
  
  func session(_ session: ARSession, didFailWithError error: Error) {}
  
  func sessionWasInterrupted(_ session: ARSession) {}
  
  func sessionInterruptionEnded(_ session: ARSession) {}
}

