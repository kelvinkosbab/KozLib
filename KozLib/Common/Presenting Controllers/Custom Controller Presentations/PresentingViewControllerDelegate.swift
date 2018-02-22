//
//  PresentingViewControllerDelegate.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/17/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

protocol PresentingViewControllerDelegate : class {
  func willPresentViewController(_ viewController: UIViewController)
  func isPresentingViewController(_ viewController: UIViewController?)
  func didPresentViewController(_ viewController: UIViewController?)
  func willDismissViewController(_ viewController: UIViewController)
  func isDismissingViewController(_ viewController: UIViewController?)
  func didDismissViewController(_ viewController: UIViewController?)
  func didCancelDissmissViewController(_ viewController: UIViewController?)
}

protocol PresentedViewControllerDelegate : class {
  func willPresentViewController()
  func isPresentingViewController()
  func didPresentViewController()
  func willDismissViewController()
  func isDismissingViewController()
  func didDismissViewController()
  func didCancelDissmissViewController()
}
