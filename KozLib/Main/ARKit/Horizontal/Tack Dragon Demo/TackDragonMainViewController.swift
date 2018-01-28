//
//  TackDragonMainViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class TackDragonMainViewController : BaseViewController {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> TackDragonMainViewController {
    return self.newViewController(fromStoryboardWithName: "TackDragon")
  }
  
  // MARK: - Properties
  
  var arViewController: TackDragonARViewController? = nil
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.largeTitleDisplayMode = .never
    self.clearNavigationBarElements()
    self.baseNavigationController?.navigationBarStyle = .transparent
    
    self.configureDefaultBackButton()
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.stopButtonSelected))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.baseNavigationController?.navigationBarStyle = .transparent
  }
  
  // MARK: - Status Bar
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Actions
  
  @objc func stopButtonSelected() {
    self.dismissController()
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let arViewController = segue.destination as? TackDragonARViewController {
      arViewController.trackingStateDelegate = self
      self.arViewController = arViewController
    }
  }
  
  // MARK: - Navigation Items
  
  func loadConfiguredNavigationBar() {
    self.navigationItem.title = "Tack Dragon"
    self.navigationItem.hidesBackButton = false
  }
  
  func clearNavigationBarElements() {
    self.navigationItem.title = nil
    self.navigationItem.rightBarButtonItem = nil
    self.navigationItem.hidesBackButton = true
  }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension TackDragonMainViewController : UIPopoverPresentationControllerDelegate {
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}

// MARK: - ARStateDelegate

extension TackDragonMainViewController : ARStateDelegate {
  
  func arStateDidUpdate(_ state: ARState) {
    switch state {
    case .configuring:
      self.title = "Configuring"
    case .limited(.insufficientFeatures):
      self.title = "Insufficent Features"
    case .limited(.excessiveMotion):
      self.title = "Excessive Motion"
    case .limited(.initializing):
      self.title = "Initializing"
    case .limited(.relocalizing):
      self.title = "Relocalizing"
    case .normal:
      self.title = "Tack Dragon"
    case .unsupported(_):
      self.title = "Unsupported Device"
    case .notAvailable:
      self.title = "❌ Not Available ❌"
    }
  }
}

