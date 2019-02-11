//
//  AnimatedPressButton.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/10/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

class AnimatedPressButton : UIButton {
  
  // MARK: - Configurable Properties
  
  var onPressTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.85, y: 0.85)
  
  // MARK: - AnimationState
  
  private enum AnimationState {
    case normal
    case pressed
    
    var animationDuration: CFTimeInterval {
      switch self {
      case .normal: return 0.2
      case .pressed: return 0.2
      }
    }
    
    var timingFunction: CAMediaTimingFunction {
      switch self {
      case .normal: return CAMediaTimingFunction(name: .easeIn)
      case .pressed: return CAMediaTimingFunction(name: .easeOut)
      }
    }
    
    var animationOptions: AnimationOptions {
      switch self {
      case .normal: return .curveEaseIn
      case .pressed: return .curveEaseOut
      }
    }
  }
  
  private var animationState: AnimationState = .normal
  
  // MARK: - Performing animations
  
  private func animate(for animationState: AnimationState) {
    UIView.animate(withDuration: animationState.animationDuration / 2, delay: 0, options: animationState.animationOptions, animations: { [weak self] in
      if let strongSelf = self {
        switch animationState {
        case .normal:
          strongSelf.transform = .identity
        case .pressed:
          strongSelf.transform = strongSelf.onPressTransform
        }
      }
    })
  }
  
  // MARK: - Touches
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    if self.animationState != .pressed {
      self.animationState = .pressed
      self.animate(for: .pressed)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    
    if self.animationState != .normal {
      self.animationState = .normal
      self.animate(for: .normal)
    }
  }
}
