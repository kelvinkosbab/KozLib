//
//  PresentationManagerProtocol.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

protocol PresenationManagerProtocol {
  var presentationInteractor: InteractiveTransition? { get set }
  var dismissInteractor: InteractiveTransition? { get set }
  init(presentationInteractor: InteractiveTransition, dismissInteractor: InteractiveTransition)
  init(presentationInteractor: InteractiveTransition)
  init(dismissInteractor: InteractiveTransition)
  init()
}
