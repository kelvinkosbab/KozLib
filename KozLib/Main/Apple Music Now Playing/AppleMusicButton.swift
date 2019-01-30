//
//  AppleMusicButton.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/26/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

class AppleMusicButton : UIButton {
  
  private let buttonLayer = CALayer()
  
  private lazy var touchCircle: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.path = UIBezierPath(ovalIn: CGRect(center: CGPoint(x: self.layer.bounds.midX, y: self.layer.bounds.midY), size: self.layer.bounds.size * 2.1)).cgPath
    layer.fillColor = UIColor.gray.cgColor
    layer.opacity = 0.0
    return layer
  }()
  
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
    self.buttonLayer.addSublayer(self.touchCircle)
    
    self.layer.insertSublayer(self.buttonLayer, at: 0)
  }
  
  // MARK: - Layer Animations
  
  private enum AnimationState {
    case `default`
    case pressed
  }
  
  private var animationState: AnimationState = .`default`
  
  private let touchDownOpacity: Float = 0.2
  private let touchUpOpacity: Float = 0
  private let touchDownDuration: CFTimeInterval = 0.1
  private let touchUpDuration: CFTimeInterval = 0.5
  
  private var timingFunction: CAMediaTimingFunction {
    return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
  }
  
  // MARK: - Touch Down
  
  func animateTouchDown() {
    self.animateOpacityTouchDown()
  }
  
  private func animateOpacityTouchDown() {
    let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
    animation.fromValue = self.touchUpOpacity
    animation.toValue = self.touchDownOpacity
    animation.duration = self.touchDownDuration
    animation.timingFunction = self.timingFunction
    
    self.touchCircle.opacity = self.touchDownOpacity
    self.touchCircle.add(animation, forKey: #keyPath(CALayer.opacity))
  }
  
  // MARK: - Touch Up
  
  func animateTouchUp() {
    self.animateOpacityTouchUp()
  }
  
  private func animateOpacityTouchUp() {
    let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
    animation.fromValue = self.touchDownOpacity
    animation.toValue = self.touchUpOpacity
    animation.duration = self.touchUpDuration
    animation.timingFunction = self.timingFunction
    
    self.touchCircle.opacity = self.touchUpOpacity
    self.touchCircle.add(animation, forKey: #keyPath(CALayer.opacity))
  }
  
  // MARK: - Touches
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    if self.animationState != .pressed {
      self.animationState = .pressed
      self.animateTouchDown()
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    
    if self.animationState != .default {
      self.animationState = .default
      self.animateTouchUp()
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
