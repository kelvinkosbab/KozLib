//
//  InteractiveTransition.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/22/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class InteractiveTransition : UIPercentDrivenInteractiveTransition {
  
  // MARK: - Properties
  
  let interactiveViews: [UIView]
  let axis: InteractiveTransition.Axis
  let direction: InteractiveTransition.Direction
  weak var delegate: InteractiveTransitionDelegate? = nil
  
  let gestureType: InteractiveTransition.GestureType
  let contentSize: CGSize?
  let percentThreshold: CGFloat
  let velocityThreshold: CGFloat
  
  private(set) var hasStarted: Bool = false
  private var shouldFinish: Bool = false
  private var activeGestureRecognizers: [UIPanGestureRecognizer] = []
  
  private var lastTranslation: CGPoint? = nil
  private var lastTranslationDate: Date? = nil
  private var lastVelocity: CGFloat? = nil
  
  // MARK: - Init
  
  init?(interactiveViews: [UIView], axis: InteractiveTransition.Axis, direction: InteractiveTransition.Direction, gestureType: GestureType = .pan, options: [InteractiveTransition.Option] = [], delegate: InteractiveTransitionDelegate? = nil) {
    
    guard interactiveViews.count > 0 else {
      return nil
    }
    
    self.interactiveViews = interactiveViews
    self.axis = axis
    self.direction = direction
    self.delegate = delegate
    
    self.gestureType = options.gestureType
    self.contentSize = options.contentSize
    self.percentThreshold = options.percentThreshold
    self.velocityThreshold = options.velocityThreshold
    
    super.init()
    
    // Configure the dismiss interactive gesture recognizer
    for interactiveView in interactiveViews {
      let gestureRecognizer = self.gestureType.createGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)), axis: self.axis, direction: self.direction)
      gestureRecognizer.delegate = self
      interactiveView.isUserInteractionEnabled = true
      interactiveView.addGestureRecognizer(gestureRecognizer)
      self.activeGestureRecognizers.append(gestureRecognizer)
    }
  }
  
  // MARK: - Gestures
  
  @objc private func handleGesture(_ sender: UIPanGestureRecognizer) {
    
    guard let view = sender.view, self.interactiveViews.contains(view) else {
      return
    }
    
    // Convert position to progress
    let translation = sender.translation(in: view)
    let progress = self.calculateProgress(translation: translation, in: view)
    
    // Velocity calculations
    self.updateVelocityProperties(currentTranslation: translation)
    
    // Handle the gesture state
    self.handleGestureState(gesture: sender, progress: progress)
  }
  
  private func handleGestureState(gesture: UIPanGestureRecognizer, progress: CGFloat) {
    switch gesture.state {
    case .began:
      self.hasStarted = true
      self.delegate?.interactionDidSurpassThreshold(self)
    case .changed:
      self.update(progress)
      self.shouldFinish = self.calculateShouldFinish(progress: progress, velocity: self.lastVelocity)
    case .cancelled:
      self.hasStarted = false
      self.cancel()
    case .ended:
      self.hasStarted = false
      self.shouldFinish ? self.finish() : self.cancel()
    default: break
    }
  }
  
  // MARK: - Overrides
  
  override func finish() {
    self.lastTranslation = nil
    self.lastTranslationDate = nil
    self.lastVelocity = nil
    super.finish()
  }
  
  override func cancel() {
    self.lastTranslation = nil
    self.lastTranslationDate = nil
    self.lastVelocity = nil
    super.cancel()
  }
  
  // MARK: - Calculations
  
  private func updateVelocityProperties(currentTranslation: CGPoint) {
    let currentDate: Date = Date()
    if self.lastTranslation == nil && self.lastTranslationDate == nil {
      self.lastVelocity = nil
      self.lastTranslation = currentTranslation
      self.lastTranslationDate = currentDate
      
    } else if let lastTranslation = self.lastTranslation, let lastTranslationDate = self.lastTranslationDate, let velocity = self.calculateVelocity(lastTranslation: lastTranslation, lastTranslationDate: lastTranslationDate, currentTranslation: currentTranslation, currentTranslationDate: currentDate), (self.direction == .negative && velocity < 0) || (self.direction == .positive && velocity > 0) {
      self.lastVelocity = velocity
      self.lastTranslation = currentTranslation
      self.lastTranslationDate = currentDate
    }
  }
  
  private func calculateShouldFinish(progress: CGFloat, velocity: CGFloat?) -> Bool {
    if progress > self.percentThreshold {
      return true
    } else if let velocity = velocity, abs(velocity) > self.velocityThreshold {
      return true
    }
    return false
  }
  
  private func calculateProgress(translation: CGPoint, in view: UIView) -> CGFloat {
    let xMovement = (self.direction == .negative ? -translation.x : translation.x) / (self.contentSize?.width ?? view.bounds.width)
    let yMovement = (self.direction == .negative ? -translation.y : translation.y) / (self.contentSize?.height ?? view.bounds.height)
    
    let movement: CGFloat
    switch self.axis {
    case .x:
      movement = xMovement
    case .y:
      movement = yMovement
    case .xy:
      movement = CGFloat(sqrt(pow(Double(xMovement), 2) + pow(Double(yMovement), 2)))
    }
    
    return CGFloat(min(max(Double(movement), 0.0), 1.0))
  }
  
  private func calculateVelocity(lastTranslation: CGPoint, lastTranslationDate: Date, currentTranslation: CGPoint, currentTranslationDate: Date) -> CGFloat? {
    
    let duration = currentTranslationDate.timeIntervalSince(lastTranslationDate)
    guard duration != 0 else {
      return nil
    }
    
    let xVelocity: Double = Double(currentTranslation.x - lastTranslation.x) / duration
    let yVelocity: Double = Double(currentTranslation.y - lastTranslation.y) / duration
    
    switch self.axis {
    case .x:
      return CGFloat(xVelocity)
    case .y:
      return CGFloat(yVelocity)
    case .xy:
      return sqrt(CGFloat(pow(xVelocity, 2) + pow(yVelocity, 2)))
    }
  }
}

// MARK: - UIGestureRecognizerDelegate

extension InteractiveTransition : UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    // gestureRecognizer is the activeGestureRecognizer associated with this interactive transition
    if gestureRecognizer.view == otherGestureRecognizer.view, let scrollView = gestureRecognizer.view as? UIScrollView {
      if self.axis == .y && self.direction == .positive && scrollView.contentOffset.y <= 0 {
        return true
      } else if self.axis == .y && self.direction == .negative && scrollView.contentOffset.y >= scrollView.contentSize.height {
        return true
      } else if self.axis == .x && self.direction == .positive && scrollView.contentOffset.x <= 0 {
        return true
      } else if self.axis == .x && self.direction == .negative && scrollView.contentOffset.x >= scrollView.contentSize.width {
        return true
      }
    }
    return false
  }
}
