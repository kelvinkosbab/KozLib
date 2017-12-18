//
//  Locale+Util.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 12/1/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import Foundation

struct Country : Hashable {
  
  let code: String
  let name: String
  
  var hashValue: Int {
    return self.code.hashValue
  }
  
  static func ==(lhs: Country, rhs: Country) -> Bool {
    return lhs.code == rhs.code
  }
}

extension Locale {
  
  static var isoCountryCodes: [String] {
    return NSLocale.isoCountryCodes as [String]
  }
  
  static func localeIdentifier(fromComponents components: [String : String]) -> String {
    return NSLocale.localeIdentifier(fromComponents: components)
  }
  
  static var countries: [Country] {
    var countries: [Country] = []
    for code in NSLocale.isoCountryCodes {
      let id = NSLocale.localeIdentifier(fromComponents: [String(NSLocale.Key.countryCode._rawValue) : code])
      if let currentLanguage = self.preferredLanguages.first, let name = NSLocale(localeIdentifier: currentLanguage).displayName(forKey: .identifier, value: id) {
        let country = Country(code: code, name: name)
        countries.append(country)
      }
    }
    let sortedCountries = countries.sorted { (country1, country2) -> Bool in
      return country1.name < country2.name
    }
    return sortedCountries
  }
}
