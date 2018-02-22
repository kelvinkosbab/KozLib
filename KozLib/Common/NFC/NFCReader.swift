//
//  NFCReader.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import Foundation
import CoreNFC

protocol NFCReaderDelegate {
  func didDetectMessageGroup(_ reader: NFCReader, messageGroup: NFCMessageGroup)
  func didUpdateMessagesGroups(_ reader: NFCReader, messagesGroups: [NFCMessageGroup])
}

class NFCReader : NSObject {
  
  // MARK: - Properties
  
  private var session: NFCNDEFReaderSession? = nil
  var messageGroups: [NFCMessageGroup] = []
  var delegate: NFCReaderDelegate? = nil
  
  // MARK: - Methods
  
  func beginSession() {
    let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
    self.session = nil
    session.begin()
  }
  
  func invalidateSession() {
    self.session?.invalidate()
    self.messageGroups = []
  }
}

extension NFCReader : NFCNDEFReaderSessionDelegate {
  
  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    print("NFCReader : Detected \(messages.count) NDEF Messages")
    let messageGroup = NFCMessageGroup(messages: messages, detectionDate: Date())
    self.delegate?.didDetectMessageGroup(self, messageGroup: messageGroup)
    self.delegate?.didUpdateMessagesGroups(self, messagesGroups: self.messageGroups)
  }
  
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    print("NFCReader : NFC NDEF Invalidated : \(error.localizedDescription)")
    self.session = nil
  }
}
