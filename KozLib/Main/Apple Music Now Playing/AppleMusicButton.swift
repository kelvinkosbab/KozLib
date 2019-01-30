//
//  AppleMusicButton.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/26/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

class AppleMusicButton : UIButton {
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.configureLayers()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.configureLayers()
  }
  
  private func configureLayers() {
    self.clipsToBounds = false
    self.backgroundColor = .clear
    
    self.buttonLayer.frame = self.bounds
    self.buttonLayer.addSublayer(self.circleLayer)
    
    self.layer.insertSublayer(self.buttonLayer, at: 0)
  }
  
  // MARK: - Configurable Properties
  
  var onPressTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.85, y: 0.85)
  
  var onPressBoundsMultiplier: CGFloat = 2 {
    didSet {
      self.circleLayer.path = self.circleLayerPath
    }
  }
  
  var circleLayerColor: UIColor? = .gray {
    didSet {
      self.circleLayer.fillColor = self.circleLayerColor?.cgColor
    }
  }
  
  // MARK: - Layers
  
  private let buttonLayer = CALayer()
  
  private lazy var circleLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.path = self.circleLayerPath
    layer.fillColor = self.circleLayerColor?.cgColor
    layer.opacity = 0.0
    return layer
  }()
  
  private var circleLayerPath: CGPath {
    let center = CGPoint(x: self.layer.bounds.midX, y: self.layer.bounds.midY)
    let minDimension = min(self.layer.bounds.width, self.layer.bounds.height) * 2
    let size = CGSize(width: minDimension, height: minDimension)
    let rect = CGRect(origin: center.applying(CGAffineTransform(translationX: size.width / -2, y: size.height / -2)), size: size)
    return UIBezierPath(ovalIn: rect).cgPath
  }
  
  // MARK: - AnimationState
  
  private enum AnimationState {
    case normal
    case pressed
    
    var fromOpacity: Float {
      switch self {
      case .normal: return 0.2
      case .pressed: return 0
      }
    }
    
    var toOpacity: Float {
      switch self {
      case .normal: return 0
      case .pressed: return 0.2
      }
    }
    
    var animationDuration: CFTimeInterval {
      switch self {
      case .normal: return 0.1
      case .pressed: return 0.5
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
    CATransaction.begin()
    CATransaction.setAnimationDuration(animationState.animationDuration)
    CATransaction.setAnimationTimingFunction(animationState.timingFunction)
    
    // Circle layer opacity animation
    self.animateCircleLayerOpacity(for: animationState, isBatchAnimation: true)
    
    // Size transform animation
    self.animateScale(for: animationState)
    
    // Commit the animation
    CATransaction.commit()
  }
  
  private func animateCircleLayerOpacity(for animationState: AnimationState, isBatchAnimation: Bool) {
    let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
    animation.fromValue = animationState.fromOpacity
    animation.toValue = animationState.toOpacity
    if isBatchAnimation {
      animation.duration = animationState.animationDuration
      animation.timingFunction = animationState.timingFunction
    }
    
    self.circleLayer.opacity = animationState.toOpacity
    self.circleLayer.add(animation, forKey: #keyPath(CALayer.opacity))
  }
  
  private func animateScale(for animationState: AnimationState) {
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

class AppleMusicRoundedButton : UIButton {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.layer.cornerRadius = 8
    self.layer.masksToBounds = true
    self.clipsToBounds = true
  }
}
