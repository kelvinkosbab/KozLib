//
//  iDev2018_BadgeViewLayerAnimationsViewController.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 8/28/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit
import QuartzCore

// MARK: - Extensions to Sotre Constants

fileprivate extension CGFloat {
  static var outerCircleRatio: CGFloat = 0.8
  static var innerCircleRatio: CGFloat = 0.55
  static var inProgressRatio: CGFloat = 0.58
}

fileprivate extension Double {
  static var animationDuration: Double = 0.5
  static var inProgressPeriod: Double = 2.0
}

fileprivate extension CALayer {
  
  func applyPopShadow() {
    shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    shadowOffset = .zero
    shadowRadius = 1
    shadowOpacity = 0.1
  }
}

extension CGRect {
  
  public init(center: CGPoint, size: CGSize) {
    self.init(origin: center.applying(CGAffineTransform(translationX: size.width / -2, y: size.height / -2)), size: size)
  }
  
  public var center: CGPoint {
    return CGPoint(x: midX, y: midY)
  }
  
  public var largestContainedSquare: CGRect {
    let side = min(width, height)
    return CGRect(center: center, size: CGSize(width: side, height: side))
  }
  
  public var smallestContainingSquare: CGRect {
    let side = max(width, height)
    return CGRect(center: center, size: CGSize(width: side, height: side))
  }
}

extension CGSize {
  
  public func rescale(_ scale: CGFloat) -> CGSize {
    return applying(CGAffineTransform(scaleX: scale, y: scale))
  }
}

// MARK: - PseudoConnection

public final class PseudoConnection: NSObject {
  public enum State {
    case disconnected
    case connecting
    case connected
  }
  private var state: State = .disconnected {
    didSet {
      stateChangeCallback(state)
    }
  }
  
  public typealias StateChange = ((State) -> ())
  private let stateChangeCallback: StateChange
  
  public init(stateChangeCallback: @escaping StateChange) {
    self.stateChangeCallback = stateChangeCallback
  }
  
  public func connect() {
    state = .connecting
    Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
      self?.state = .connected
    }
  }
  
  public func disconnect() {
    state = .disconnected
  }
  
  @objc public func toggle() {
    switch state {
    case .disconnected:
      connect()
    default:
      disconnect()
    }
  }
}

// MARK: - Badge UIBezierPath

public extension UIBezierPath {
  
  public static var badgePath: UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 199.91, y: 41.87))
    path.addCurve(to: CGPoint(x: 194.36, y: 35.26), controlPoint1: CGPoint(x: 199.83, y: 38.56), controlPoint2: CGPoint(x: 197.55, y: 35.71))
    path.addCurve(to: CGPoint(x: 150.43, y: 23.99), controlPoint1: CGPoint(x: 179.48, y: 33.14), controlPoint2: CGPoint(x: 164.81, y: 29.45))
    path.addCurve(to: CGPoint(x: 103.19, y: 0.96), controlPoint1: CGPoint(x: 136.11, y: 18.55), controlPoint2: CGPoint(x: 120.27, y: 10.95))
    path.addCurve(to: CGPoint(x: 96.82, y: 0.96), controlPoint1: CGPoint(x: 101.02, y: -0.31), controlPoint2: CGPoint(x: 98.98, y: -0.32))
    path.addCurve(to: CGPoint(x: 49.7, y: 23.99), controlPoint1: CGPoint(x: 79.85, y: 10.95), controlPoint2: CGPoint(x: 64.13, y: 18.53))
    path.addCurve(to: CGPoint(x: 5.89, y: 35.26), controlPoint1: CGPoint(x: 35.31, y: 29.43), controlPoint2: CGPoint(x: 20.65, y: 33.14))
    path.addCurve(to: CGPoint(x: 0.1, y: 41.87), controlPoint1: CGPoint(x: 2.7, y: 35.71), controlPoint2: CGPoint(x: 0.46, y: 38.56))
    path.addCurve(to: CGPoint(x: 39.78, y: 196.11), controlPoint1: CGPoint(x: -1.31, y: 104.72), controlPoint2: CGPoint(x: 11.96, y: 156.14))
    path.addCurve(to: CGPoint(x: 96.82, y: 249.03), controlPoint1: CGPoint(x: 54.94, y: 217.88), controlPoint2: CGPoint(x: 73.91, y: 235.55))
    path.addCurve(to: CGPoint(x: 103.43, y: 249.03), controlPoint1: CGPoint(x: 98.59, y: 250.38), controlPoint2: CGPoint(x: 101.36, y: 250.27))
    path.addCurve(to: CGPoint(x: 160.23, y: 196.11), controlPoint1: CGPoint(x: 126.16, y: 235.33), controlPoint2: CGPoint(x: 145.11, y: 217.78))
    path.addCurve(to: CGPoint(x: 199.91, y: 41.87), controlPoint1: CGPoint(x: 188.09, y: 156.16), controlPoint2: CGPoint(x: 201.25, y: 104.72))
    path.close()
    return path
  }
}

// MARK: - Badge button view

class BadgeButtonView: UIView {
  private let buttonLayer = CALayer()
  private lazy var innerCircle: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.path = UIBezierPath(ovalIn: CGRect(center: buttonLayer.bounds.center, size: buttonLayer.bounds.size.rescale(CGFloat.innerCircleRatio))).cgPath
    layer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    layer.shadowRadius = 15
    layer.shadowOpacity = 0.1
    layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    layer.shadowOffset = CGSize(width: 15, height: 25)
    layer.lineWidth = 3
    layer.strokeColor = #colorLiteral(red: 0.6670270491, green: 0.6670270491, blue: 0.6670270491, alpha: 1)
    layer.opacity = 1.0
    return layer
  }()
  
  private lazy var outerCircle: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.path = UIBezierPath(ovalIn: CGRect(center: buttonLayer.bounds.center, size: buttonLayer.bounds.size.rescale(CGFloat.outerCircleRatio))).cgPath
    layer.fillColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    layer.applyPopShadow()
    layer.opacity = 0.4
    return layer
  }()
  
  private lazy var greenBackground: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.path = UIBezierPath(ovalIn: CGRect(center: buttonLayer.frame.center, size: buttonLayer.bounds.size.rescale(CGFloat.innerCircleRatio))).cgPath
    layer.fillColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    layer.mask = createBadgeMaskLayer()
    
    return layer
  }()
  
  private lazy var inProgressLayer: CAGradientLayer = {
    let layer = CAGradientLayer()
    layer.colors = [#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), UIColor(white: 1, alpha: 0)].map{ $0.cgColor }
    layer.locations = [0, 0.7].map { NSNumber(floatLiteral: $0) }
    layer.frame = CGRect(center: buttonLayer.bounds.center, size: buttonLayer.bounds.size.rescale(CGFloat.inProgressRatio))
    
    let mask = CAShapeLayer()
    
    mask.path = UIBezierPath(ovalIn: CGRect(center: layer.bounds.center, size: layer.bounds.size)).cgPath
    mask.fillColor = UIColor.black.cgColor
    layer.mask = mask
    layer.isHidden = true
    return layer
  }()
  
  private lazy var badgeLayer: CAGradientLayer = {
    let layer = CAGradientLayer()
    layer.colors = [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0.8880859375, green: 0.8880859375, blue: 0.8880859375, alpha: 1)].map { $0.cgColor }
    layer.frame = self.layer.bounds
    layer.applyPopShadow()
    layer.mask = createBadgeMaskLayer()
    return layer
  }()
  
  private func createBadgeMaskLayer() -> CAShapeLayer {
    let scale = self.layer.bounds.width / UIBezierPath.badgePath.bounds.width
    let mask = CAShapeLayer()
    mask.path = UIBezierPath.badgePath.cgPath
    mask.transform = CATransform3DMakeScale(scale, scale, 1)
    return mask
  }
  
  enum State {
    case off
    case inProgress
    case on
  }
  
  public var state: State = .off {
    didSet {
      switch state {
      case .inProgress:
        showInProgress(true)
      case .on:
        showInProgress(false)
        animateToOn()
      case .off:
        showInProgress(false)
        animateToOff()
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureLayers()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureLayers()
  }
  
  private func configureLayers() {
    backgroundColor = #colorLiteral(red: 0.9600390625, green: 0.9600390625, blue: 0.9600390625, alpha: 1)
    
    buttonLayer.frame = bounds.largestContainedSquare.offsetBy(dx: 0, dy: -20)
    buttonLayer.addSublayer(outerCircle)
    buttonLayer.addSublayer(inProgressLayer)
    buttonLayer.addSublayer(innerCircle)
    
    layer.addSublayer(badgeLayer)
    layer.addSublayer(greenBackground)
    layer.addSublayer(buttonLayer)
  }
  
  private func animateToOn() {
    let path = UIBezierPath(ovalIn: CGRect(center: bounds.center, size: bounds.smallestContainingSquare.size.rescale(sqrt(2)))).cgPath
    let animation = CABasicAnimation(keyPath: "path")
    animation.fromValue = greenBackground.path
    animation.toValue = path
    animation.duration = Double.animationDuration
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    
    greenBackground.add(animation, forKey: "onAnimation")
    greenBackground.path = path
  }
  
  private func animateToOff() {
    let animation = CABasicAnimation(keyPath: "path")
    animation.fromValue = greenBackground.path
    animation.toValue = UIBezierPath(ovalIn: CGRect(center: buttonLayer.frame.center, size: buttonLayer.bounds.size.rescale(CGFloat.innerCircleRatio))).cgPath
    animation.duration = Double.animationDuration
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    
    greenBackground.add(animation, forKey: "offAnimation")
    greenBackground.path = UIBezierPath(ovalIn: CGRect(center: buttonLayer.frame.center, size: buttonLayer.bounds.size.rescale(CGFloat.innerCircleRatio))).cgPath
  }
  
  private func showInProgress(_ show: Bool = true) {
    if show {
      let animation = CABasicAnimation(keyPath: "transform.rotation.z")
      animation.fromValue = 0
      animation.toValue = 2 * Double.pi
      animation.duration = Double.inProgressPeriod
      animation.repeatCount = .greatestFiniteMagnitude
      inProgressLayer.add(animation, forKey: "inProgressAnimation")
      inProgressLayer.isHidden = false
    } else {
      inProgressLayer.isHidden = true
      inProgressLayer.removeAnimation(forKey: "inProgressAnimation")
    }
  }
}

// MARK: - iDev2018_BadgeViewLayerAnimationsViewController

class iDev2018_BadgeViewLayerAnimationsViewController : BaseViewController {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> iDev2018_BadgeViewLayerAnimationsViewController {
    return self.newViewController(fromStoryboardWithName: "360iDev2018")
  }
  
  // MARK: - Properties
  
  lazy var badgeButton: BadgeButtonView = {
    return BadgeButtonView(frame: CGRect(x: 0, y: 0, width: 300, height: 300 / aspectRatio))
  }()
  
  var aspectRatio: CGFloat {
    return UIBezierPath.badgePath.bounds.width / UIBezierPath.badgePath.bounds.height
  }
  
  lazy var pseudoConnection: PseudoConnection = {
    let pseudoConnection = PseudoConnection { (state) in
      switch state {
      case .disconnected:
        self.badgeButton.state = .off
        Log.log("Disconnected")
      case .connecting:
        self.badgeButton.state = .inProgress
        Log.log("Connecting")
      case .connected:
        self.badgeButton.state = .on
        Log.log("Connected")
      }
    }
    return pseudoConnection
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Title
    self.navigationItem.title = "Badge Button Animation"
    self.navigationItem.largeTitleDisplayMode = .never
    
    // Navigation elements
    self.configureDefaultBackButton()
    
    // Add and configure the badge to the view
    self.view.addSubview(self.badgeButton)
    self.badgeButton.translatesAutoresizingMaskIntoConstraints = false
    let width = NSLayoutConstraint(item: self.badgeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
    let height = NSLayoutConstraint(item: self.badgeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 400)
    self.badgeButton.addConstraints([ width, height ])
    let centerX = NSLayoutConstraint(item: self.badgeButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
    let centerY = NSLayoutConstraint(item: self.badgeButton, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
    self.view.addConstraints([ centerX, centerY ])
    
    // Configure the pseudo connection listener
    let gesture = UITapGestureRecognizer(target: pseudoConnection, action: #selector(PseudoConnection.toggle))
    self.badgeButton.addGestureRecognizer(gesture)
  }
}
