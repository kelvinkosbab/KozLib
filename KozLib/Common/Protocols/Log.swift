//
//  Log.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation

struct Log : Loggable {
  private init() {}
}

protocol Loggable {}
extension Loggable {
  
  // MARK: - Static
  
  static var isLoggingEnabled: Bool {
    return true
  }
  
  static func log(_ message: String, file: String = #file, line: Int = #line, function: String = #function) {
    self.printMessage("\(self.stackCallerClassAndMethodString(file: file, line: line, function: function)) - \(message)")
  }
  
  static func extendedLog(_ message: String, emoji: String = "✅✅✅", file: String = #file, line: Int = #line, function: String = #function) {
    self.printMessage("<<< \(emoji) \(self.stackCallerClassAndMethodString(file: file, line: line, function: function)) : \(message) \(emoji) >>>")
  }
  
  static func logMethodExecution(emoji: String = "✅✅✅", file: String = #file, line: Int = #line, function: String = #function) {
    self.printMessage("<<< \(emoji) \(self.stackCallerClassAndMethodString(file: file, line: line, function: function)) \(emoji) >>>")
  }
  
  static func logFullStackData() {
    let sourceString = Thread.callStackSymbols[1]
    let separatorSet = CharacterSet.init(charactersIn: " -[]+?.,")
    let array = sourceString.components(separatedBy: separatorSet)
    
    self.printMessage("****** Stack: \(array[0])")
    self.printMessage("****** Framework: \(array[1])")
    self.printMessage("****** Memory address: \(array[2])")
    self.printMessage("****** Class caller: \(array[3])")
    self.printMessage("****** Function caller: \(array[4])")
    self.printMessage("****** Line caller: \(array[5])")
  }
  
  static func stackCallerClassAndMethodString(file: String, line: Int, function: String) -> String {
    let lastPathComponent = (file as NSString).lastPathComponent
    return "\(lastPathComponent):\(line) : \(function)"
  }
  
  static internal func printMessage(_ message: String) {
    if self.isLoggingEnabled {
      print(message)
    }
  }
}

