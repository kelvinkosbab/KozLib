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
  @IBOutlet weak var notificationsPermissionButton: UIButton!
  @IBOutlet weak var notificationsActivityIndicatorView: UIActivityIndicatorView!
  
  weak var delegate: PermissionsViewControllerDelegate? = nil
  
  var isLocationAuthorized: Bool {
    return LocationManager.shared.isAccessAuthorized
  }
  
  var isLocationNotDetermined: Bool {
    return LocationManager.shared.isAccessNotDetermined
  }
  
  var isCameraAuthorized: Bool = CameraPermissionManager.shared.isAccessAuthorized
  var isCameraNotDetermined: Bool = CameraPermissionManager.shared.isAccessNotDetermined
  
  var isNotificationsAuthorized: Bool = NotificationManager.shared.isAccessAuthorized
  var isNotificationsNotDetermined: Bool = NotificationManager.shared.isAccessNotDetermined
  
  var areAllPermissionAuthorized: Bool {
    return self.isLocationAuthorized && self.isCameraAuthorized && self.isNotificationsAuthorized
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
    self.notificationsActivityIndicatorView.isHidden = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    LocationManager.shared.authorizationDelegate = self
    CameraPermissionManager.shared.authorizationDelegate = self
    NotificationManager.shared.authorizationDelegate = self
    self.isCameraAuthorized = CameraPermissionManager.shared.isAccessAuthorized
    self.isCameraNotDetermined = CameraPermissionManager.shared.isAccessNotDetermined
    self.isNotificationsNotDetermined = NotificationManager.shared.isAccessNotDetermined
    self.isNotificationsNotDetermined = NotificationManager.shared.isAccessNotDetermined
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
    
    // Notifications
    if self.isNotificationsAuthorized {
      self.notificationsPermissionButton.setTitle("Notifications Access Granted", for: .normal)
      self.notificationsPermissionButton.isUserInteractionEnabled = false
      self.notificationsPermissionButton.setTitleColor(.lightGray, for: .normal)
    } else {
      self.notificationsPermissionButton.setTitle("Allow Notifications Access", for: .normal)
      self.notificationsPermissionButton.isUserInteractionEnabled = true
      self.notificationsPermissionButton.setTitleColor(.cyan, for: .normal)
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
  
  @IBAction func notificationsPermissionButtonSelected() {
    
    // Check if access has been denied - Settings
    guard self.isNotificationsNotDetermined else {
      self.showSettingsAlert()
      return
    }
    
    // Show loading
    self.notificationsActivityIndicatorView.isHidden = false
    self.notificationsActivityIndicatorView.startAnimating()
    self.notificationsPermissionButton.isUserInteractionEnabled = false
    self.notificationsPermissionButton.isHidden = true
    
    // Request permissions
    NotificationManager.shared.requestAuthorization()
  }
  
  private func showSettingsAlert() {
    let alertController = UIAlertController (title: "Action Required", message: "Go to Settings?", preferredStyle: .alert)
    
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ -> Void in
      
      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
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
    self.isCameraNotDetermined = false
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

extension PermissionsViewController : NotificationPermissionDelegate {
  
  func notificationDidUpdateAuthorization(status: PermissionAuthorizationStatus) {
    self.isNotificationsAuthorized = status == .authorized
    self.isNotificationsNotDetermined = status == .notDetermined
    if self.areAllPermissionAuthorized {
      self.delegate?.didAuthorizeAllPermissions()
    }
    
    // Update the content
    self.reloadContent()
    
    // Stop loading
    self.notificationsActivityIndicatorView.stopAnimating()
    self.notificationsActivityIndicatorView.isHidden = true
    self.notificationsPermissionButton.isUserInteractionEnabled = true
    self.notificationsPermissionButton.isHidden = false
  }
}
