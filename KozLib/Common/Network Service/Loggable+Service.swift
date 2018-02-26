//
//  Loggable+Service.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation

extension Loggable {
  
  static func log(_ apiResponse: APIResponse, file: String = #file, line: Int = #line, function: String = #function) {
    switch apiResponse {
    case .error(let error):
      self.printMessage("\n<<< ❌❌❌ \(self.stackCallerClassAndMethodString(file: file, line: line, function: function)) : \(error.localizedDescription) ❌❌❌ >>>\n")
    case .success:
      self.printMessage("\(self.stackCallerClassAndMethodString(file: file, line: line, function: function)) : Success ✅")
    }
  }
  
  static func log(_ serviceResponse: ServiceResponse, httpMethod: String? = nil, endpoint: String, file: String = #file, line: Int = #line, function: String = #function) {
    let methodString: String
    if let httpMethod = httpMethod {
      methodString = "\(httpMethod) "
    } else {
      methodString = ""
    }
    switch serviceResponse {
    case .error(let error, _):
      self.printMessage("\n<<< ❌❌❌ \(self.stackCallerClassAndMethodString(file: file, line: line, function: function)) : \(methodString)\(endpoint) \(error.localizedDescription) ❌❌❌ >>>\n")
    case .success(_):
      self.printMessage("\(self.stackCallerClassAndMethodString(file: file, line: line, function: function)) : \(methodString)\(endpoint) Success ✅")
    }
  }
}
