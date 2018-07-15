//
//  ServiceError.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 7/15/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation

enum ServiceError {
  case badRequest(error: Error)
  case unauthorized(error: Error)
  case forbidden(error: Error)
  case notFound(error: Error)
  case timeout(error: Error)
  case locked(error: Error)
  case other(error: Error, statusCode: Int)
  
  var statusCode: Int {
    switch self {
    case .badRequest(error: _):
      return 400
    case .unauthorized(error: _):
      return 401
    case .forbidden(error: _):
      return 403
    case .notFound(error: _):
      return 404
    case .timeout(error: _):
      return 408
    case .locked(error: _):
      return 423
    case .other(error: _, statusCode: let statusCode):
      return statusCode
    }
  }
  
  var error: Error {
    switch self {
    case .badRequest(error: let error), .unauthorized(error: let error), .forbidden(error: let error), .notFound(error: let error), .timeout(error: let error), .locked(error: let error), .other(error: let error, statusCode: _):
      return error
    }
  }
  
  static func generate(error: Error, statusCode: Int?) -> ServiceError {
    
    guard let statusCode = statusCode else {
      return .badRequest(error: error)
    }
    
    switch statusCode {
    case 400: return .badRequest(error: error)
    case 401: return .unauthorized(error: error)
    case 403: return .forbidden(error: error)
    case 404: return .notFound(error: error)
    case 408: return .timeout(error: error)
    case 423: return .locked(error: error)
    default: return .other(error: error, statusCode: statusCode)
    }
  }
}
