//
//  HapticsGenerator.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 7/14/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation

#if os(watchOS)
import WatchKit
#else
import UIKit
#endif

final class HapticsGenerator {
  
  // MARK: - watchOS
  
  #if os(watchOS)
  
  enum Haptic {
    case notification, success, failure, retry, start, stop, click
    
    internal var hapticType: WKHapticType {
      switch self {
      case .notification: return .notification
      case .success: return .success
      case .failure: return .failure
      case .retry: return .retry
      case .start: return .start
      case .stop: return .stop
      case .click: return .click
      }
    }
  }
  
  private let watchKitInterfaceDevice = WKInterfaceDevice.current()
  
  func generate(_ haptic: Haptic) {
    DispatchQueue.main.async {
      self.watchKitInterfaceDevice.play(haptic.hapticType)
    }
  }
  
  #else
  
  // MARK: - iOS
  
  enum Haptic {
    case notification(NotificationHaptic), selection, impact(ImpactHaptic)
  }
  
  enum NotificationHaptic {
    case success, warning, error
    
    internal var feedbackType: UINotificationFeedbackGenerator.FeedbackType {
      switch self {
      case .success: return .success
      case .warning: return .warning
      case .error: return .error
      }
    }
  }
  
  enum ImpactHaptic {
    case light, medium, heavy
    
    internal var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle {
      switch self {
      case .light: return .light
      case .medium: return .medium
      case .heavy: return .heavy
      }
    }
  }
  
  func generate(_ haptic: Haptic) {
    switch haptic {
    case .selection:
      let selection = UISelectionFeedbackGenerator()
      DispatchQueue.main.async {
        selection.selectionChanged()
      }
    case .notification(let haptic):
      let notification = UINotificationFeedbackGenerator()
      DispatchQueue.main.async {
        notification.notificationOccurred(haptic.feedbackType)
      }
    case .impact(let haptic):
      let impact = UIImpactFeedbackGenerator(style: haptic.feedbackStyle)
      DispatchQueue.main.async {
        impact.impactOccurred()
      }
    }
  }
  
  #endif
}
