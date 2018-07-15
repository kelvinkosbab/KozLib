//
//  ARFaceTrackingViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

/*
 * Source: https://developer.apple.com/documentation/arkit/creating_face_based_ar_experiences
 */

class ARFaceTrackingViewController : BaseViewController, ARSessionDelegate, DismissInteractable {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> ARFaceTrackingViewController {
    return self.newViewController(fromStoryboardWithName: "ARFaceTracking")
  }
  
  // MARK: - DismissInteractable
  
  var dismissInteractiveViews: [UIView] {
    if let view = self.view {
      return [ view ]
    }
    return []
  }
  
  // MARK: Outlets
  
  @IBOutlet var sceneView: ARSCNView!
  
  @IBOutlet weak var blurView: UIVisualEffectView!
  
  lazy var statusViewController: ARFaceTrackingStatusViewController = {
    return childViewControllers.lazy.compactMap({ $0 as? ARFaceTrackingStatusViewController }).first!
  }()
  
  // MARK: Properties
  
  /// Convenience accessor for the session owned by ARSCNView.
  var session: ARSession {
    return sceneView.session
  }
  
  var nodeForContentType = [VirtualContentType: VirtualFaceNode]()
  
  let contentUpdater = VirtualContentUpdater()
  
  var selectedVirtualContent: VirtualContentType = .overlayModel {
    didSet {
      // Set the selected content based on the content type.
      contentUpdater.virtualFaceNode = nodeForContentType[selectedVirtualContent]
    }
  }
  
  // MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Face Tracking"
    self.navigationItem.largeTitleDisplayMode = .never
    self.baseNavigationController?.navigationBarStyle = .transparent
    
    self.configureDefaultBackButton()
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.stopButtonSelected))
    
    sceneView.delegate = contentUpdater
    sceneView.session.delegate = self
    sceneView.automaticallyUpdatesLighting = true
    
    createFaceGeometry()
    
    // Set the initial face content, if any.
    contentUpdater.virtualFaceNode = nodeForContentType[selectedVirtualContent]
    
    // Hook up status view controller callback(s).
    statusViewController.restartExperienceHandler = { [unowned self] in
      self.restartExperience()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.baseNavigationController?.navigationBarStyle = .transparent
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    /*
     AR experiences typically involve moving the device without
     touch input for some time, so prevent auto screen dimming.
     */
    UIApplication.shared.isIdleTimerDisabled = true
    
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
  
  // MARK: - Setup
  
  /// - Tag: CreateARSCNFaceGeometry
  func createFaceGeometry() {
    
    // Check if simulator
    
    #if targetEnvironment(simulator)
    return
    #else
    
    // This relies on the earlier check of `ARFaceTrackingConfiguration.isSupported`.
    guard let device = sceneView.device,
      let maskGeometry = ARSCNFaceGeometry(device: device),
      let glassesGeometry = ARSCNFaceGeometry(device: device) else {
        return
    }
    
    nodeForContentType = [
      .faceGeometry: Mask(geometry: maskGeometry),
      .overlayModel: GlassesOverlay(geometry: glassesGeometry),
      .blendShapeModel: RobotHead()
    ]
    
    #endif
  }
  
  // MARK: - ARSessionDelegate
  
  func session(_ session: ARSession, didFailWithError error: Error) {
    guard error is ARError else { return }
    
    let errorWithInfo = error as NSError
    let messages = [
      errorWithInfo.localizedDescription,
      errorWithInfo.localizedFailureReason,
      errorWithInfo.localizedRecoverySuggestion
    ]
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
    
    DispatchQueue.main.async {
      self.resetTracking()
    }
  }
  
  /// - Tag: ARFaceTrackingSetup
  func resetTracking() {
    statusViewController.showMessage("STARTING A NEW SESSION")
    
    guard ARFaceTrackingConfiguration.isSupported else { return }
    let configuration = ARFaceTrackingConfiguration()
    configuration.isLightEstimationEnabled = true
    session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
  }
  
  // MARK: - Interface Actions
  
  /// - Tag: restartExperience
  func restartExperience() {
    // Disable Restart button for a while in order to give the session enough time to restart.
    statusViewController.isRestartExperienceButtonEnabled = false
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
      self.statusViewController.isRestartExperienceButtonEnabled = true
    }
    
    resetTracking()
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
}

// MARK: - UIPopoverPresentationControllerDelegate

extension ARFaceTrackingViewController : UIPopoverPresentationControllerDelegate {
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    /*
     Popover segues should not adapt to fullscreen on iPhone, so that
     the AR session's view controller stays visible and active.
     */
    return .none
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    /*
     All segues in this app are popovers even on iPhone. Configure their popover
     origin accordingly.
     */
    guard let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton else { return }
    popoverController.delegate = self
    popoverController.sourceRect = button.bounds
    
    // Set up the view controller embedded in the popover.
    let contentSelectionController = popoverController.presentedViewController as! ARFaceTrackingContentSelectionController
    
    // Set the initially selected virtual content.
    contentSelectionController.selectedVirtualContent = selectedVirtualContent
    
    // Update our view controller's selected virtual content when the selection changes.
    contentSelectionController.selectionHandler = { [unowned self] newSelectedVirtualContent in
      self.selectedVirtualContent = newSelectedVirtualContent
    }
  }
}
