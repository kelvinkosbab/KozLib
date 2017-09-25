//
//  DragRightDismissInteractiveTransition.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class DragRightDismissInteractiveTransition : InteractiveTransition {
  
  override var axis: InteractiveTransition.InteractorAxis {
    return .x
  }
  
  override var direction: InteractiveTransition.InteractorDirection {
    return .positive
  }
}
