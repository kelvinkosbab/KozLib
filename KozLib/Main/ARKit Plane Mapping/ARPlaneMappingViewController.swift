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

class ARPlaneMappingViewController : BaseViewController {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> ARPlaneMappingViewController {
    return self.newViewController(fromStoryboardWithName: "ARKit")
  }
  
  // MARK: - Properties
  
  @IBOutlet weak var sceneView: ARSCNView!
  
  var screenCenter: CGPoint? = nil
  
  let session = ARSession()
  var sessionConfig: ARConfiguration = ARWorldTrackingConfiguration()
  
  var trackingFallbackTimer: Timer?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupScene()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIApplication.shared.isIdleTimerDisabled = true
    self.restartPlaneDetection()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    self.session.pause()
  }
  
  // MARK: - Status Bar
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

// MARK: - AR Scene

extension ARPlaneMappingViewController : ARSCNViewDelegate {
  
  func setupScene() {
    self.sceneView.setUp(delegate: self, session: self.session)
    DispatchQueue.main.async {
      self.screenCenter = self.sceneView.bounds.mid
    }
  }
  
  func restartPlaneDetection() {
    // configure session
    if let worldSessionConfig = self.sessionConfig as? ARWorldTrackingConfiguration {
      worldSessionConfig.planeDetection = .horizontal
      self.session.run(worldSessionConfig, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // reset timer
    if self.trackingFallbackTimer != nil {
      self.trackingFallbackTimer!.invalidate()
      self.trackingFallbackTimer = nil
    }
    
//    textManager.scheduleMessage("FIND A SURFACE TO PLACE AN OBJECT", inSeconds: 7.5, messageType: .planeEstimation)
  }
  
  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
//    textManager.showTrackingQualityInfo(for: camera.trackingState, autoHide: !self.showDebugVisuals)
//
//    switch camera.trackingState {
//    case .notAvailable:
//      textManager.escalateFeedback(for: camera.trackingState, inSeconds: 5.0)
//    case .limited:
//      if use3DOFTrackingFallback {
//        // After 10 seconds of limited quality, fall back to 3DOF mode.
//        trackingFallbackTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { _ in
//          self.use3DOFTracking = true
//          self.trackingFallbackTimer?.invalidate()
//          self.trackingFallbackTimer = nil
//        })
//      } else {
//        textManager.escalateFeedback(for: camera.trackingState, inSeconds: 10.0)
//      }
//    case .normal:
//      textManager.cancelScheduledMessage(forType: .trackingStateEscalation)
//      if use3DOFTrackingFallback && trackingFallbackTimer != nil {
//        trackingFallbackTimer!.invalidate()
//        trackingFallbackTimer = nil
//      }
//    }
  }
  
  func session(_ session: ARSession, didFailWithError error: Error) {
//    guard let arError = error as? ARError else { return }
//
//    let nsError = error as NSError
//    var sessionErrorMsg = "\(nsError.localizedDescription) \(nsError.localizedFailureReason ?? "")"
//    if let recoveryOptions = nsError.localizedRecoveryOptions {
//      for option in recoveryOptions {
//        sessionErrorMsg.append("\(option).")
//      }
//    }
//
//    let isRecoverable = (arError.code == .worldTrackingFailed)
//    if isRecoverable {
//      sessionErrorMsg += "\nYou can try resetting the session or quit the application."
//    } else {
//      sessionErrorMsg += "\nThis is an unrecoverable error that requires to quit the application."
//    }
//
//    displayErrorMessage(title: "We're sorry!", message: sessionErrorMsg, allowRestart: isRecoverable)
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
//    textManager.blurBackground()
//    textManager.showAlert(title: "Session Interrupted", message: "The session will be reset after the interruption has ended.")
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
//    textManager.unblurBackground()
//    session.run(sessionConfig, options: [.resetTracking, .removeExistingAnchors])
//    restartExperience(self)
//    textManager.showMessage("RESETTING SESSION")
  }
}
