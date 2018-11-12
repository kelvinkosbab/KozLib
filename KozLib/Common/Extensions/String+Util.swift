//
//  String+Util.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

extension String {
  
  // MARK: - Util
  
  var trim: String {
    return self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  var urlEncoded: String? {
    return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
  }
  
  var urlDecoded: String? {
    return self.removingPercentEncoding
  }
  
  func contains(string: String) -> Bool {
    return self.range(of: string) != nil
  }
  
  func containsIgnoreCase(string: String) -> Bool {
    return self.lowercased().range(of: string.lowercased()) != nil
  }
  
  var withoutWhitespace: String {
    return self.components(separatedBy: CharacterSet.whitespacesAndNewlines).joined(separator: "")
  }
  
  var isAlphanumeric: Bool {
    return self.components(separatedBy: self.homeKitCharacterSet).joined(separator: "").isEmpty
  }
  
  var alphaNumeric: String {
    return self.components(separatedBy: self.homeKitCharacterSet.inverted).joined(separator: "")
  }
  
  private var homeKitCharacterSet: CharacterSet {
    let allowedSymbols = CharacterSet(charactersIn: "'")
    var combined = CharacterSet.alphanumerics.union(CharacterSet.whitespaces).union(allowedSymbols)
    combined.remove(charactersIn: ".")
    return combined
  }
  
  // MARK: - Subscript Operations
  
  subscript (i: Int) -> String {
    return self[Range(i ..< i + 1)]
  }
  
  func substring(from: Int) -> String {
    return self[Range(min(from, self.count) ..< self.count)]
  }
  
  func substring(to: Int) -> String {
    return self[Range(0 ..< max(0, to))]
  }
  
  subscript (r: Range<Int>) -> String {
    let range = Range(uncheckedBounds: (lower: max(0, min(self.count, r.lowerBound)), upper: min(self.count, max(0, r.upperBound))))
    let start = index(startIndex, offsetBy: range.lowerBound)
    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
    return String(self[start ..< end])
  }
  
  // MARK: - Email Utilities
  
  var isEmailAddress: Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
  }
  
  var reducedEmailFormat: String {
    let emailSeparator = "@"
    let cencoredCharacter = "•"
    
    let components = self.components(separatedBy: emailSeparator)
    guard components.count > 1, let firstComponent = components.first else {
      return self
    }
    
    switch firstComponent.count {
    case 1:
      var adjustedComponents = components
      adjustedComponents[0] = cencoredCharacter
      return adjustedComponents.joined(separator: emailSeparator)
      
    case 2...5:
      let censored = String(repeating: cencoredCharacter, count: firstComponent.count - 1)
      let firstCharacter = firstComponent[0]
      let censoredEmail = "\(firstCharacter)\(censored)"
      var adjustedComponents = components
      adjustedComponents[0] = censoredEmail
      return adjustedComponents.joined(separator: emailSeparator)
      
    default:
      let censored = String(repeating: cencoredCharacter, count: 2)
      let emailStart = firstComponent.substring(to: 2)
      let emailEnd = firstComponent.substring(from: firstComponent.count - 2)
      let censoredEmail = "\(emailStart)\(censored)\(emailEnd)"
      var adjustedComponents = components
      adjustedComponents[0] = censoredEmail
      return adjustedComponents.joined(separator: emailSeparator)
    }
  }
  
  // MARK: - Base64
  
  var base64Encoded: String? {
    return self.data(using: .utf8)?.base64EncodedString()
  }
  
  var base64Decoded: String? {
    if let data = Data(base64Encoded: self) {
      return String(data: data, encoding: .utf8)
    }
    return nil
  }
  
  var isBase64: Bool {
    if let base64Decoded = self.base64Decoded, !base64Decoded.isEmpty {
      return true
    }
    return false
  }
  
  // MARK: - Labels
  
  func heightWithConstrainedWidth(label: UILabel) -> CGFloat {
    let width = label.bounds.width
    let font = label.font
    return self.heightWithConstrainedWidth(width: width, font: font!)
  }
  
  func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    return boundingBox.height + 25
  }
  
  func calculateSize(font: UIFont) -> CGSize {
    return (self as NSString).size(withAttributes: [ NSAttributedString.Key.font : font ])
  }
  
  func calculateWidth(font: UIFont) -> CGFloat {
    return self.calculateSize(font: font).width
  }
}

