//
//  Data+JSON.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation

extension Data {
  
  var json: Any? {
    return try? JSONSerialization.jsonObject(with: self, options: [])
  }
  
  var jsonDictionary: [AnyHashable : Any]? {
    if let object = try? JSONSerialization.jsonObject(with: self, options: []), let json = object as? [AnyHashable : Any] {
      return json
    }
    return nil
  }
  
  var jsonArray: [Any]? {
    if let object = try? JSONSerialization.jsonObject(with: self, options: []), let array = object as? [Any] {
      return array
    }
    return nil
  }
}
