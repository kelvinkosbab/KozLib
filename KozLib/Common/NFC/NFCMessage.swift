//
//  NFCMessage.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import Foundation
import CoreNFC

struct NFCMessageGroup {
  let messages: [NFCNDEFMessage]
  let detectionDate: Date
}
