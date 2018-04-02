//
//  SessionManager.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation
import Alamofire

class SessionManager {
  
  // MARK: - Init
  
  init(configurationType: ConfigurationType, baseEndpoint: String? = nil, authenticationState: AuthenticationState = .unauthorized) {
    self.baseEndpoint = baseEndpoint
    self.configurationType = configurationType
    self.sessionManager = Alamofire.SessionManager(configuration: configurationType.configuration)
    self.authenticationState = authenticationState
  }
  
  // MARK: - Properties
  
  static let defaultTimeoutInterval: TimeInterval = 20
  
  var baseEndpoint: String? = nil
  var authenticationState: AuthenticationState = .unauthorized
  private var sessionManager: Alamofire.SessionManager
  
  var configurationType: ConfigurationType {
    didSet {
      self.sessionManager = Alamofire.SessionManager(configuration: self.configurationType.configuration)
    }
  }
  
  // MARK: - Configuration Type
  
  enum ConfigurationType {
    case standard(TimeInterval), background(TimeInterval), local(TimeInterval?)
    
    var configuration: URLSessionConfiguration {
      switch self {
      case .standard(let timeoutInterval):
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.timeoutIntervalForRequest = timeoutInterval
        configuration.timeoutIntervalForResource = timeoutInterval
        return configuration
      case .background(let timeoutInterval):
        let configuration = URLSessionConfiguration.background(withIdentifier: "SessionManager.ConfigurationType.backgroundConfiguration.\(UUID().uuidString)")
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.timeoutIntervalForRequest = timeoutInterval
        configuration.timeoutIntervalForResource = timeoutInterval
        return configuration
      case .local(let timeoutInterval):
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval ?? 60
        configuration.timeoutIntervalForResource = timeoutInterval ?? 60
        configuration.allowsCellularAccess = false
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return configuration
      }
    }
  }
  
  // MARK: - HTTP Methods
  
  private func getDataRequest(endpoint: String, method: HTTPMethod, parameters: Parameters?) -> DataRequest? {
    do {
      // Build the url request
      let endpoint = "\(self.baseEndpoint ?? "")\(endpoint)"
      var urlRequest = try URLRequest(url: endpoint, method: method)
      
      // Request body
      if let parameters = parameters {
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
      }
      
      // Content type
      urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
      
      // Authorization
      switch self.authenticationState {
      case .authorized(let username, let password):
        if let base64Credentials = "\(username):\(password)".base64Encoded {
          urlRequest.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        }
      case .unauthorized:
        break
      }
      
      let dataRequest = self.sessionManager.request(urlRequest)
      dataRequest.validate()
      return dataRequest
      
    } catch {
      Log.extendedLog("Error generating data request \(error.localizedDescription)", emoji: "❌❌❌")
      return nil
    }
  }
  
  func get(endpoint: String, parameters: [String : Any]?, completion: @escaping (_ response: SessionManagerResponse) -> Void) {
    let dataRequest = self.getDataRequest(endpoint: endpoint, method: .get, parameters: parameters)
    dataRequest?.responseJSON { response in
      let urlResponse = response.response
      switch response.result {
      case .success(let response):
        completion(.success(response, urlResponse))
      case .failure(let error):
        let json = response.data?.json
        completion(.error(error, json, urlResponse))
      }
    }
  }
  
  func put(endpoint: String, parameters: [String : Any]?, completion: @escaping (_ response: SessionManagerResponse) -> Void) {
    let dataRequest = self.getDataRequest(endpoint: endpoint, method: .put, parameters: parameters)
    dataRequest?.responseJSON { response in
      let urlResponse = response.response
      switch response.result {
      case .success(let response):
        completion(.success(response, urlResponse))
      case .failure(let error):
        let json = response.data?.json
        completion(.error(error, json, urlResponse))
      }
    }
  }
  
  func post(endpoint: String, parameters: [String : Any]?, completion: @escaping (_ response: SessionManagerResponse) -> Void) {
    let dataRequest = self.getDataRequest(endpoint: endpoint, method: .post, parameters: parameters)
    dataRequest?.responseJSON { response in
      let urlResponse = response.response
      switch response.result {
      case .success(let response):
        completion(.success(response, urlResponse))
      case .failure(let error):
        let json = response.data?.json
        completion(.error(error, json, urlResponse))
      }
    }
  }
  
  func delete(endpoint: String, parameters: [String : Any]?, completion: @escaping (_ response: SessionManagerResponse) -> Void) {
    let dataRequest = self.getDataRequest(endpoint: endpoint, method: .delete, parameters: parameters)
    dataRequest?.responseJSON { response in
      let urlResponse = response.response
      switch response.result {
      case .success(let response):
        completion(.success(response, urlResponse))
      case .failure(let error):
        let json = response.data?.json
        completion(.error(error, json, urlResponse))
      }
    }
  }
}
