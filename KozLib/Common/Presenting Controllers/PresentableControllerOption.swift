//
//  PresentableControllerOption.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

enum PresentableControllerOption {
  case withoutNavigationController, presentingViewControllerDelegate(PresentingViewControllerDelegate), presentedViewControllerDelegate(PresentedViewControllerDelegate)
}

extension Sequence where Iterator.Element == PresentableControllerOption {
  
  var inNavigationController: Bool {
    return !self.contains { option -> Bool in
      switch option {
      case .withoutNavigationController:
        return true
      default:
        return false
      }
    }
  }
  
  var presentingViewControllerDelegate: PresentingViewControllerDelegate? {
    for option in self {
      switch option {
      case .presentingViewControllerDelegate(let presentingViewControllerDelegate):
        return presentingViewControllerDelegate
      default: break
      }
    }
    return nil
  }
  
  var presentedViewControllerDelegate: PresentedViewControllerDelegate? {
    for option in self {
      switch option {
      case .presentedViewControllerDelegate(let presentedViewControllerDelegate):
        return presentedViewControllerDelegate
      default: break
      }
    }
    return nil
  }
}
