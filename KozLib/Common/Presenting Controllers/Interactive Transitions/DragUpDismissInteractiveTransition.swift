//
//  DragUpDismissInteractiveTransition.swift
//  KozLib
//
//  Created by Kelvin Kosbab on 9/24/17.
//  Copyright © 2017 Kozinga. All rights reserved.
//

import UIKit

class DragUpDismissInteractiveTransition : InteractiveTransition {
  
  override var axis: InteractiveTransition.InteractorAxis {
    return .y
  }
  
  override var direction: InteractiveTransition.InteractorDirection {
    return .negative
  }
}
