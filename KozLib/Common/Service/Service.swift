//
//  Service.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation

class Service : Hashable, Loggable, ClassNamable {
  
  // MARK: - Init
  
  init(endpoint: String? = nil, sessionConfigurationType: SessionManager.ConfigurationType = .standard(SessionManager.defaultTimeoutInterval)) {
    self.sessionConfigurationType = sessionConfigurationType
    self.endpoint = endpoint
    self.sessionManager = SessionManager(configurationType: self.sessionConfigurationType, baseEndpoint: self.endpoint)
  }
  
  // MARK: - Hashable
  
  var hashValue: Int {
    return self.endpoint?.hashValue ?? 0
  }
  
  static func == (lhs: Service, rhs: Service) -> Bool {
    return lhs.endpoint == rhs.endpoint
  }
  
  // MARK: - Properties
  
  internal var sessionManager: SessionManager
  internal var sessionConfigurationType: SessionManager.ConfigurationType = .standard(SessionManager.defaultTimeoutInterval) {
    didSet {
      self.sessionManager = SessionManager(configurationType: self.sessionConfigurationType, baseEndpoint: self.endpoint)
    }
  }
  
  var endpoint: String? {
    didSet {
      self.sessionManager.baseEndpoint = self.endpoint
    }
  }
  
  // MARK: - HTTP Methods
  
  final func get(endpoint: String, parameters: [String : Any]?, file: String = #file, line: Int = #line, function: String = #function, completion: @escaping (_ response: ServiceResponse) -> Void) {
    self.sessionManager.get(endpoint: endpoint, parameters: parameters) { response in
      Log.log(response, httpMethod: "GET", endpoint: endpoint, file: file, line: line, function: function)
      completion(response)
    }
  }
  
  final func put(endpoint: String, parameters: [String : Any]?, file: String = #file, line: Int = #line, function: String = #function, completion: @escaping (_ response: ServiceResponse) -> Void) {
    self.sessionManager.put(endpoint: endpoint, parameters: parameters) { response in
      Log.log(response, httpMethod: "PUT", endpoint: endpoint, file: file, line: line, function: function)
      completion(response)
    }
  }
  
  final func post(endpoint: String, parameters: [String : Any]?, file: String = #file, line: Int = #line, function: String = #function, completion: @escaping (_ response: ServiceResponse) -> Void) {
    self.sessionManager.post(endpoint: endpoint, parameters: parameters) { response in
      Log.log(response, httpMethod: "POST", endpoint: endpoint, file: file, line: line, function: function)
      completion(response)
    }
  }
  
  final func delete(endpoint: String, parameters: [String : Any]?, file: String = #file, line: Int = #line, function: String = #function, completion: @escaping (_ response: ServiceResponse) -> Void) {
    self.sessionManager.delete(endpoint: endpoint, parameters: parameters) { response in
      Log.log(response, httpMethod: "DELETE", endpoint: endpoint, file: file, line: line, function: function)
      completion(response)
    }
  }
}
