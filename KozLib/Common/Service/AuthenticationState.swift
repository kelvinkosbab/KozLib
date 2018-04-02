//
//  AuthenticationState.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/25/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import Foundation

enum AuthenticationState {
  case unauthorized, authorized(String,String)
}
