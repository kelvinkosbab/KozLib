//
//  PresentingViewControllerDelegate.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/17/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

protocol PresentingViewControllerDelegate : class {
  func willPresentViewController(_ viewController: UIViewController, usingMode: PresentationMode)
  func isPresentingViewController(_ viewController: UIViewController?, usingMode: PresentationMode)
  func didPresentViewController(_ viewController: UIViewController?, usingMode: PresentationMode)
  func willDismissViewController(_ viewController: UIViewController, usingMode: PresentationMode)
  func isDismissingViewController(_ viewController: UIViewController?, usingMode: PresentationMode)
  func didDismissViewController(_ viewController: UIViewController?, usingMode: PresentationMode)
  func didCancelDissmissViewController(_ viewController: UIViewController?, usingMode: PresentationMode)
}

protocol PresentedViewControllerDelegate : class {
  func willPresentViewController(usingMode: PresentationMode)
  func isPresentingViewController(usingMode: PresentationMode)
  func didPresentViewController(usingMode: PresentationMode)
  func willDismissViewController(usingMode: PresentationMode)
  func isDismissingViewController(usingMode: PresentationMode)
  func didDismissViewController(usingMode: PresentationMode)
  func didCancelDissmissViewController(usingMode: PresentationMode)
}
