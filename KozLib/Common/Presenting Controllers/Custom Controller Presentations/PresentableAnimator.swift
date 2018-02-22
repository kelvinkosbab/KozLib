//
//  PresentableAnimator.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

protocol PresentableAnimator : UIViewControllerAnimatedTransitioning {
  var presentingViewControllerDelegate: PresentingViewControllerDelegate? { get set }
  var presentedViewControllerDelegate: PresentedViewControllerDelegate? { get set }
}
