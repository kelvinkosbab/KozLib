//
//  Service.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation

protocol ServiceDelegate : class {
  func receivedLockedStatus()
  func clearLockedStatus()
  func receivedUnauthorizedStatus()
}

extension Int {
  
  var isUnauthorizedStatusCode: Bool {
    return self == 401
  }
  
  var isLockedStatusCode: Bool {
    return self == 423
  }
}

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
  
  weak var delegate: ServiceDelegate? = nil
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
    self.sessionManager.get(endpoint: endpoint, parameters: parameters) { [weak self] response in
      if let strongSelf = self {
        switch response {
        case .success(let response, let urlResponse):
          let response = strongSelf.handleResponse(urlResponse: urlResponse, httpMethod: "GET", endpoint: endpoint, response: response, file: file, line: line, function: function)
          completion(response)
        case .error(let error, let response, let urlResponse):
          let response = strongSelf.handleResponse(urlResponse: urlResponse, error: error, httpMethod: "GET", endpoint: endpoint, response: response, file: file, line: line, function: function)
          completion(response)
        }
      }
    }
  }
  
  final func put(endpoint: String, parameters: [String : Any]?, file: String = #file, line: Int = #line, function: String = #function, completion: @escaping (_ response: ServiceResponse) -> Void) {
    self.sessionManager.put(endpoint: endpoint, parameters: parameters) { [weak self] response in
      if let strongSelf = self {
        switch response {
        case .success(let response, let urlResponse):
          let response = strongSelf.handleResponse(urlResponse: urlResponse, httpMethod: "PUT", endpoint: endpoint, response: response, file: file, line: line, function: function)
          completion(response)
        case .error(let error, let response, let urlResponse):
          let response = strongSelf.handleResponse(urlResponse: urlResponse, error: error, httpMethod: "PUT", endpoint: endpoint, response: response, file: file, line: line, function: function)
          completion(response)
        }
      }
    }
  }
  
  final func post(endpoint: String, parameters: [String : Any]?, file: String = #file, line: Int = #line, function: String = #function, completion: @escaping (_ response: ServiceResponse) -> Void) {
    self.sessionManager.post(endpoint: endpoint, parameters: parameters) { [weak self] response in
      if let strongSelf = self {
        switch response {
        case .success(let response, let urlResponse):
          let response = strongSelf.handleResponse(urlResponse: urlResponse, httpMethod: "POST", endpoint: endpoint, response: response, file: file, line: line, function: function)
          completion(response)
        case .error(let error, let response, let urlResponse):
          let response = strongSelf.handleResponse(urlResponse: urlResponse, error: error, httpMethod: "POST", endpoint: endpoint, response: response, file: file, line: line, function: function)
          completion(response)
        }
      }
    }
  }
  
  final func delete(endpoint: String, parameters: [String : Any]?, file: String = #file, line: Int = #line, function: String = #function, completion: @escaping (_ response: ServiceResponse) -> Void) {
    self.sessionManager.delete(endpoint: endpoint, parameters: parameters) { [weak self] response in
      if let strongSelf = self {
        switch response {
        case .success(let response, let urlResponse):
          let response = strongSelf.handleResponse(urlResponse: urlResponse, httpMethod: "DELETE", endpoint: endpoint, response: response, file: file, line: line, function: function)
          completion(response)
        case .error(let error, let response, let urlResponse):
          let response = strongSelf.handleResponse(urlResponse: urlResponse, error: error, httpMethod: "DELETE", endpoint: endpoint, response: response, file: file, line: line, function: function)
          completion(response)
        }
      }
    }
  }
  
  func handleResponse(urlResponse: HTTPURLResponse?, httpMethod: String, endpoint: String, response: Any?, file: String, line: Int, function: String) -> ServiceResponse {
    let response = ServiceResponse.success(response)
    let endpoint = urlResponse?.url?.path ?? endpoint
    Log.log(response, httpMethod: httpMethod, endpoint: endpoint, file: file, line: line, function: function)
    return response
  }
  
  func handleResponse(urlResponse: HTTPURLResponse?, error: Error, httpMethod: String, endpoint: String, response: Any?, file: String, line: Int, function: String) -> ServiceResponse {
    let response = ServiceResponse.error(error, response)
    let endpoint = urlResponse?.url?.path ?? endpoint
    Log.log(response, httpMethod: httpMethod, endpoint: endpoint, file: file, line: line, function: function)
    return response
  }
}
