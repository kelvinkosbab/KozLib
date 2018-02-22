//
//  InteractiveTransition.Option.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

extension InteractiveTransition {
  
  enum Axis {
    case x, y, xy
  }
  
  enum Direction {
    case negative, positive
  }
  
  enum Option {
    case percent(CGFloat), velocity(CGFloat), contentSize(CGSize), gestureType(InteractiveTransition.GestureType)
    
    static let defaultPercentThreshold: CGFloat = 0.3
    static let defaultVelocityThreshold: CGFloat = 850
  }
  
  enum GestureType {
    case pan, screenEdgePan
    
    func createGestureRecognizer(target: Any?, action: Selector?, axis: InteractiveTransition.Axis, direction: InteractiveTransition.Direction) -> UIPanGestureRecognizer {
      switch self {
      case .pan:
        return UIPanGestureRecognizer(target: target, action: action)
      case .screenEdgePan:
        let test = UIScreenEdgePanGestureRecognizer(target: target, action: action)
        switch axis {
        case .x:
          switch direction {
          case .positive:
            test.edges = .left
          case .negative:
            test.edges = .right
          }
        case .y:
          switch direction {
          case .positive:
            test.edges = .top
          case .negative:
            test.edges = .bottom
          }
        case .xy:
          test.edges = .all
        }
        return test
      }
    }
  }
}

extension Sequence where Iterator.Element == InteractiveTransition.Option {
  
  var percentThreshold: CGFloat {
    for option in self {
      switch option {
      case .percent(let threshold):
        return threshold
      default: break
      }
    }
    return 0.3
  }
  
  var velocityThreshold: CGFloat {
    for option in self {
      switch option {
      case .velocity(let threshold):
        return threshold
      default: break
      }
    }
    return 850
  }
  
  var gestureType: InteractiveTransition.GestureType {
    for option in self {
      switch option {
      case .gestureType(let gestureType):
        return gestureType
      default: break
      }
    }
    return .pan
  }
  
  var contentSize: CGSize? {
    for option in self {
      switch option {
      case .contentSize(let size):
        return size
      default: break
      }
    }
    return nil
  }
}
