//
//  PermissionsViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

protocol PermissionsViewControllerDelegate : class {
  func didAuthorizeAllPermissions()
}

class PermissionsViewController : BaseViewController {
  
  // MARK: - Static Accessors
  
  private static func newViewController() -> PermissionsViewController {
    return self.newViewController(fromStoryboardWithName: "Permissions")
  }
  
  static func newViewController(delegate: PermissionsViewControllerDelegate?) -> PermissionsViewController {
    let viewController = self.newViewController()
    viewController.delegate = delegate
    return viewController
  }
  
  // MARK: - Properties
  
  @IBOutlet weak var locationPermissionButton: UIButton!
  @IBOutlet weak var locationActivityIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var cameraPermissionButton: UIButton!
  @IBOutlet weak var cameraActivityIndicatorView: UIActivityIndicatorView!
  
  weak var delegate: PermissionsViewControllerDelegate? = nil
  
  var isLocationAuthorized: Bool {
    return LocationManager.shared.isAccessAuthorized
  }
  
  var isLocationNotDetermined: Bool {
    return LocationManager.shared.isAccessNotDetermined
  }
  
  var isCameraAuthorized: Bool = CameraPermissionManager.shared.isAccessAuthorized
  var isCameraNotDetermined: Bool = CameraPermissionManager.shared.isAccessNotDetermined
  
  var areAllPermissionAuthorized: Bool {
    return self.isLocationAuthorized && self.isCameraAuthorized
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Permissions"
    self.navigationItem.largeTitleDisplayMode = .never
    self.baseNavigationController?.navigationBarStyle = .transparent
    
    self.configureDefaultBackButton()
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.stopButtonSelected))
    
    self.locationActivityIndicatorView.isHidden = true
    self.cameraActivityIndicatorView.isHidden = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    LocationManager.shared.authorizationDelegate = self
    CameraPermissionManager.shared.authorizationDelegate = self
    self.isCameraAuthorized = CameraPermissionManager.shared.isAccessAuthorized
    self.isCameraNotDetermined = CameraPermissionManager.shared.isAccessNotDetermined
    self.reloadContent()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Actions
  
  @objc func stopButtonSelected() {
    self.dismissController()
  }
  
  // MARK: - Content
  
  func reloadContent() {
    
    // Location
    if self.isLocationAuthorized {
      self.locationPermissionButton.setTitle("Location Access Granted", for: .normal)
      self.locationPermissionButton.isUserInteractionEnabled = false
      self.locationPermissionButton.setTitleColor(.lightGray, for: .normal)
    } else {
      self.locationPermissionButton.setTitle("Allow Location Access", for: .normal)
      self.locationPermissionButton.isUserInteractionEnabled = true
      self.locationPermissionButton.setTitleColor(.cyan, for: .normal)
    }
    
    // Camera
    if self.isCameraAuthorized {
      self.cameraPermissionButton.setTitle("Camera Access Granted", for: .normal)
      self.cameraPermissionButton.isUserInteractionEnabled = false
      self.cameraPermissionButton.setTitleColor(.lightGray, for: .normal)
    } else {
      self.cameraPermissionButton.setTitle("Allow Camera Access", for: .normal)
      self.cameraPermissionButton.isUserInteractionEnabled = true
      self.cameraPermissionButton.setTitleColor(.cyan, for: .normal)
    }
  }
  
  // MARK: - Actions
  
  @IBAction func locationPermissionButtonSelected() {
    
    // Check if access has been denied - Settings
    guard self.isLocationNotDetermined else {
      self.showSettingsAlert()
      return
    }
    
    // Show loading
    self.locationActivityIndicatorView.isHidden = false
    self.locationActivityIndicatorView.startAnimating()
    self.locationPermissionButton.isUserInteractionEnabled = false
    self.locationPermissionButton.isHidden = true
    
    // Request permissions
    LocationManager.shared.requestAuthorization()
  }
  
  @IBAction func cameraPermissionButtonSelected() {
    
    // Check if access has been denied - Settings
    guard self.isCameraNotDetermined else {
      self.showSettingsAlert()
      return
    }
    
    // Show loading
    self.cameraActivityIndicatorView.isHidden = false
    self.cameraActivityIndicatorView.startAnimating()
    self.cameraPermissionButton.isUserInteractionEnabled = false
    self.cameraPermissionButton.isHidden = true
    
    // Request permissions
    CameraPermissionManager.shared.requestAuthorization()
  }
  
  private func showSettingsAlert() {
    let alertController = UIAlertController (title: "Action Required", message: "Go to Settings?", preferredStyle: .alert)
    
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ -> Void in
      
      guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
        return
      }
      
      if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl)
      }
    }
    alertController.addAction(settingsAction)
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    alertController.addAction(cancelAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
}

// MARK: - LocationManagerAuthorizationDelegate

extension PermissionsViewController : LocationManagerAuthorizationDelegate {
  
  func locationManagerDidUpdateAuthorization() {
    
    if self.areAllPermissionAuthorized {
      self.delegate?.didAuthorizeAllPermissions()
    }
    
    // Update the content
    self.reloadContent()
    
    // Stop loading
    self.locationActivityIndicatorView.stopAnimating()
    self.locationActivityIndicatorView.isHidden = true
    self.locationPermissionButton.isUserInteractionEnabled = true
    self.locationPermissionButton.isHidden = false
  }
}

// MARK: - CameraPermissionDelegate

extension PermissionsViewController : CameraPermissionDelegate {
  
  func cameraPermissionManagerDidUpdateAuthorization(isAuthorized: Bool) {
    self.isCameraAuthorized = isAuthorized
    if self.areAllPermissionAuthorized {
      self.delegate?.didAuthorizeAllPermissions()
    }
    
    // Update the content
    self.reloadContent()
    
    // Stop loading
    self.cameraActivityIndicatorView.stopAnimating()
    self.cameraActivityIndicatorView.isHidden = true
    self.cameraPermissionButton.isUserInteractionEnabled = true
    self.cameraPermissionButton.isHidden = false
  }
}
