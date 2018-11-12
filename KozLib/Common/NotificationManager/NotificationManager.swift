//
//  NotificationManager.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 3/12/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit
import UserNotifications

protocol NotificationPermissionDelegate : class {
  func notificationDidUpdateAuthorization(status: PermissionAuthorizationStatus)
}

class NotificationManager : NSObject, PermissionManagerDelegate {
  
  // MARK: - Singleton
  
  static let shared = NotificationManager()
  
  private override init() {
    super.init()
  }
  
  // MARK: - Properties
  
  private let identifierUserInfoKey = "Kozinga.NotificationManager.identifer"
  weak var authorizationDelegate: NotificationPermissionDelegate? = nil
  
  // MARK: - PermissionManagerDelegate
  
  var status: PermissionAuthorizationStatus = .notDetermined {
    didSet {
      self.authorizationDelegate?.notificationDidUpdateAuthorization(status: self.status)
    }
  }
  
  var isAccessAuthorized: Bool {
    switch self.status {
    case .authorized:
      return true
    default:
      return false
    }
  }
  
  var isAccessDenied: Bool {
    switch self.status {
    case .denied:
      return true
    default:
      return false
    }
  }
  
  var isAccessNotDetermined: Bool {
    switch self.status {
    case .notDetermined:
      return true
    default:
      return false
    }
  }
  
  // MARK: - Authorization
  
  func requestAuthorization(completion: ((_ granted: Bool) -> Void)? = nil) {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().getNotificationSettings { notificationSettings in
        if notificationSettings.authorizationStatus == .authorized {
          DispatchQueue.main.async {
            self.status = .authorized
            completion?(true)
          }
        } else {
          UNUserNotificationCenter.current().requestAuthorization(options: [ .alert, .sound, .badge ]) { (granted, error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              self.status = granted ? .authorized : .denied
              completion?(granted)
            }
          }
        }
      }
      
    } else {
      UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [ .alert, .sound, .badge ], categories: nil))
      self.status = .authorized
      completion?(true)
    }
  }
  
  // MARK: - Scheduling Notifications
  
  @available(iOS 10.0, *)
  func scheduleLocalNotification(title: String, body: String, dateMatching dateComponents: DateComponents, identifier: String = UUID().uuidString, repeats: Bool = false) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.categoryIdentifier = "alarm"
    content.userInfo = [ self.identifierUserInfoKey : identifier ]
    content.sound = UNNotificationSound.default
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
  }
  
  func scheduleLocalNotification(title: String, body: String, triggerDate: Date) {
    self.scheduleLocalNotification(title: title, body: body, triggerDate: triggerDate, identifier:  UUID().uuidString, repeatInterval: nil)
  }
  
  func scheduleLocalNotification(title: String, body: String, triggerDate: Date, identifier: String = UUID().uuidString, repeatInterval: NSCalendar.Unit?) {
    if #available(iOS 10.0, *) {
      let dateComponents = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second ], from: triggerDate)
      self.scheduleLocalNotification(title: title, body: body, dateMatching: dateComponents, identifier: identifier)
    } else {
      let localNotification = UILocalNotification()
      localNotification.fireDate = triggerDate
      localNotification.alertBody = title
      localNotification.alertAction = body
      localNotification.userInfo = [ self.identifierUserInfoKey : identifier ]
      localNotification.soundName = UILocalNotificationDefaultSoundName
      if let repeatInterval = repeatInterval {
        localNotification.repeatCalendar = Calendar.current
        localNotification.repeatInterval = repeatInterval
      }
      UIApplication.shared.scheduleLocalNotification(localNotification)
    }
  }
  
  // MARK: - Checking if a Notification is Scheduled
  
  func getScheduledNotificationIdentifiers(completion: @escaping (_ identifiers: Set<String>) -> Void) {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
        DispatchQueue.main.async {
          
          // UNUserNotification
          let requestIdentifiers = requests.map { $0.identifier }
          
          // UILocalNotification
          let localIdentifiers = self.getUILocalNotificationIdentifiers()
          
          // Completion
          completion(Set(requestIdentifiers).union(localIdentifiers))
        }
      }
      
    } else {
      
      // UILocalNotification
      let localIdentifiers = self.getUILocalNotificationIdentifiers()
      completion(localIdentifiers)
    }
  }
  
  private func getUILocalNotificationIdentifiers() -> Set<String> {
    if #available(iOS 10.0, *) {
      return Set()
    } else {
      let scheduledLocalNotifications = UIApplication.shared.scheduledLocalNotifications ?? []
      let identifiers = scheduledLocalNotifications.map { localNotification -> String in
        if let userInfo = localNotification.userInfo, let identifier = userInfo[self.identifierUserInfoKey] as? String {
          return identifier
        }
        return ""
      }
      let filteredIdentifiers = identifiers.filter { !$0.isEmpty }
      return Set(filteredIdentifiers)
    }
  }
  
  func isLocalNotificationScheduled(identifier: String, completion: @escaping (_ isScheduled: Bool) -> Void) {
    self.getScheduledNotificationIdentifiers { identifiers in
      completion(identifiers.contains(identifier))
    }
  }
  
  func isLocalNotificationScheduled(date: Date, completion: @escaping (_ isScheduled: Bool) -> Void) {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
        DispatchQueue.main.async {
          let dateComponents = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second ], from: date)
          let isScheduled = requests.contains { request -> Bool in
            if let trigger = request.trigger as? UNCalendarNotificationTrigger {
              return trigger.dateComponents == dateComponents
            }
            return false
          }
          
          if isScheduled {
            completion(isScheduled)
          } else {
            
            // Check UILocalNotification
            let isScheduled = self.isUILocalNotificationScheduled(date: date)
            completion(isScheduled)
          }
        }
      }
      
    } else {
      
      // UILocalNotification
      let isScheduled = self.isUILocalNotificationScheduled(date: date)
      completion(isScheduled)
    }
  }
  
  private func isUILocalNotificationScheduled(date: Date) -> Bool {
    
    if #available(iOS 10.0, *) {
      return false
    } else {
      
      // UILocalNotification - pre-iOS10
      let scheduledLocalNotifications = UIApplication.shared.scheduledLocalNotifications ?? []
      let isScheduled = scheduledLocalNotifications.contains { $0.fireDate == date }
      return isScheduled
    }
  }
  
  // MARK: - Removing Local Notifications
  
  func removeLocalNotification(identifier: String) {
    
    // UNUserNotificationCenter
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [ identifier ])
      UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [ identifier ])
    } else {
      
      // UILocalNotification
      let scheduledLocalNotifications = UIApplication.shared.scheduledLocalNotifications ?? []
      let localNotifications = scheduledLocalNotifications.filter { localNotification -> Bool in
        if let userInfo = localNotification.userInfo, let userInfoIdentifier = userInfo[self.identifierUserInfoKey] as? String, userInfoIdentifier == identifier {
          return true
        }
        return false
      }
      for localNotification in localNotifications {
        UIApplication.shared.cancelLocalNotification(localNotification)
      }
    }
  }
  
  func removeLocalNotification(date: Date, completion: @escaping () -> Void) {
    
    // UNUserNotificationCenter
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
        DispatchQueue.main.async {
          let dateComponents = Calendar.current.dateComponents([ .day, .month, .year, .hour, .minute, .second ], from: date)
          let matchingNotificationRequests = notificationRequests.filter { request -> Bool in
            if let trigger = request.trigger as? UNCalendarNotificationTrigger {
              return trigger.dateComponents == dateComponents
            }
            return false
          }
          let identifiers = matchingNotificationRequests.map { request -> String in
            return request.identifier
          }
          UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
          UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
          completion()
        }
      }
    } else {
      
      // UILocalNotification
      let scheduledLocalNotifications = UIApplication.shared.scheduledLocalNotifications ?? []
      let localNotifications = scheduledLocalNotifications.filter { $0.fireDate == date }
      for localNotification in localNotifications {
        UIApplication.shared.cancelLocalNotification(localNotification)
      }
      
      DispatchQueue.main.async {
        completion()
      }
    }
  }
  
  func removeAllLocalNotifications() {
    self.removeAllPendingLocalNotifications()
    self.removeAllDeliveredLocalNotifications()
  }
  
  func removeAllPendingLocalNotifications() {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    } else {
      UIApplication.shared.cancelAllLocalNotifications()
    }
  }
  
  func removeAllDeliveredLocalNotifications() {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
  }
}
