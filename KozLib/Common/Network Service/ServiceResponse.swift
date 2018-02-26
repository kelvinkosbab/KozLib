//
//  ServiceResponse.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation

enum ServiceResponse {
  case success(Any?), error(Error, Any?)
}

enum SessionManagerResponse {
  case success(Any?, HTTPURLResponse?), error(Error, Any?, HTTPURLResponse?)
}

enum APIResponse {
  case success, error(Error)
}
