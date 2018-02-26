//
//  ARRecognizingImagesViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import ARKit
import SceneKit
import UIKit

class ARRecognizingImagesViewController: BaseViewController, ARSCNViewDelegate, DismissInteractable {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> ARRecognizingImagesViewController {
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
  
  @IBOutlet var sceneView: ARSCNView!
  
  @IBOutlet weak var blurView: UIVisualEffectView!
  
  /// The view controller that displays the status and "restart experience" UI.
  lazy var statusViewController: ARRecognizingImageStatusViewController = {
    return childViewControllers.lazy.flatMap({ $0 as? ARRecognizingImageStatusViewController }).first!
  }()
  
  /// A serial queue for thread safety when modifying the SceneKit node graph.
  let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".serialSceneKitQueue")
  
  /// Convenience accessor for the session owned by ARSCNView.
  var session: ARSession {
    return sceneView.session
  }
  
  // MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Recognizing Images"
    self.navigationItem.largeTitleDisplayMode = .never
    self.baseNavigationController?.navigationBarStyle = .transparent
    
    self.configureDefaultBackButton()
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.stopButtonSelected))
    
    sceneView.delegate = self
    sceneView.session.delegate = self
    
    // Hook up status view controller callback(s).
    statusViewController.restartExperienceHandler = { [unowned self] in
      self.restartExperience()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Prevent the screen from being dimmed to avoid interuppting the AR experience.
    UIApplication.shared.isIdleTimerDisabled = true
    
    // Start the AR experience
    resetTracking()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    session.pause()
  }
  
  // MARK: - Status Bar
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Actions
  
  @objc func stopButtonSelected() {
    self.dismissController()
  }
  
  // MARK: - Session management (Image detection setup)
  
  /// Prevents restarting the session while a restart is in progress.
  var isRestartAvailable = true
  
  /// Creates a new AR configuration to run on the `session`.
  /// - Tag: ARReferenceImage-Loading
  func resetTracking() {
    
    if #available(iOS 11.3, *) {
      
      guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
        fatalError("Missing expected asset catalog resources.")
      }
      
      let configuration = ARWorldTrackingConfiguration()
      configuration.detectionImages = referenceImages
      session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
      
      statusViewController.scheduleMessage("Look around to detect images", inSeconds: 7.5, messageType: .contentPlacement)
      
    }
  }
  
  // MARK: - ARSCNViewDelegate (Image detection results)
  /// - Tag: ARImageAnchor-Visualizing
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    if #available(iOS 11.3, *) {
      
      guard let imageAnchor = anchor as? ARImageAnchor else { return }
      let referenceImage = imageAnchor.referenceImage
      updateQueue.async {
        
        // Create a plane to visualize the initial position of the detected image.
        let plane = SCNPlane(width: referenceImage.physicalSize.width,
                             height: referenceImage.physicalSize.height)
        let planeNode = SCNNode(geometry: plane)
        planeNode.opacity = 0.25
        
        /*
         `SCNPlane` is vertically oriented in its local coordinate space, but
         `ARImageAnchor` assumes the image is horizontal in its local space, so
         rotate the plane to match.
         */
        planeNode.eulerAngles.x = -.pi / 2
        
        /*
         Image anchors are not tracked after initial detection, so create an
         animation that limits the duration for which the plane visualization appears.
         */
        planeNode.runAction(self.imageHighlightAction)
        
        // Add the plane visualization to the scene.
        node.addChildNode(planeNode)
      }
      
      DispatchQueue.main.async {
        let imageName = referenceImage.name ?? ""
        self.statusViewController.cancelAllScheduledMessages()
        self.statusViewController.showMessage("Detected image “\(imageName)”")
      }
    }
  }
  
  var imageHighlightAction: SCNAction {
    return .sequence([
      .wait(duration: 0.25),
      .fadeOpacity(to: 0.85, duration: 0.25),
      .fadeOpacity(to: 0.15, duration: 0.25),
      .fadeOpacity(to: 0.85, duration: 0.25),
      .fadeOut(duration: 0.5),
      .removeFromParentNode()
      ])
  }
}

// MARK: - ARSessionDelegate

extension ARRecognizingImagesViewController : ARSessionDelegate {
  
  // MARK: - ARSessionDelegate
  
  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    statusViewController.showTrackingQualityInfo(for: camera.trackingState, autoHide: true)
    
    switch camera.trackingState {
    case .notAvailable, .limited:
      statusViewController.escalateFeedback(for: camera.trackingState, inSeconds: 3.0)
    case .normal:
      statusViewController.cancelScheduledMessage(for: .trackingStateEscalation)
    }
  }
  
  func session(_ session: ARSession, didFailWithError error: Error) {
    guard error is ARError else { return }
    
    let errorWithInfo = error as NSError
    let messages = [
      errorWithInfo.localizedDescription,
      errorWithInfo.localizedFailureReason,
      errorWithInfo.localizedRecoverySuggestion
    ]
    
    // Use `flatMap(_:)` to remove optional error messages.
    let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
    
    DispatchQueue.main.async {
      self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
    }
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
    blurView.isHidden = false
    statusViewController.showMessage("""
        SESSION INTERRUPTED
        The session will be reset after the interruption has ended.
        """, autoHide: false)
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
    blurView.isHidden = true
    statusViewController.showMessage("RESETTING SESSION")
    
    restartExperience()
  }
  
  func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
    return true
  }
  
  // MARK: - Error handling
  
  func displayErrorMessage(title: String, message: String) {
    // Blur the background.
    blurView.isHidden = false
    
    // Present an alert informing about the error that has occurred.
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
      alertController.dismiss(animated: true, completion: nil)
      self.blurView.isHidden = true
      self.resetTracking()
    }
    alertController.addAction(restartAction)
    present(alertController, animated: true, completion: nil)
  }
  
  // MARK: - Interface Actions
  
  func restartExperience() {
    guard isRestartAvailable else { return }
    isRestartAvailable = false
    
    statusViewController.cancelAllScheduledMessages()
    
    resetTracking()
    
    // Disable restart for a while in order to give the session time to restart.
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
      self.isRestartAvailable = true
    }
  }
}
