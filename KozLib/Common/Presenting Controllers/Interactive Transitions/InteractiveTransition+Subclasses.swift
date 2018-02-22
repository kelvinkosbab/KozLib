//
//  InteractiveTransition+Subclasses.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/19/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

// MARK: - DragUpDismissInteractiveTransition

class DragUpDismissInteractiveTransition : InteractiveTransition {
  
  init?(interactiveViews: [UIView], options: [InteractiveTransition.Option] = [], delegate: InteractiveTransitionDelegate? = nil) {
    super.init(interactiveViews: interactiveViews, axis: .y, direction: .negative, options: options, delegate: delegate)
  }
}

// MARK: - DragDownDismissInteractiveTransition

class DragDownDismissInteractiveTransition : InteractiveTransition {
  
  init?(interactiveViews: [UIView], options: [InteractiveTransition.Option] = [], delegate: InteractiveTransitionDelegate? = nil) {
    super.init(interactiveViews: interactiveViews, axis: .y, direction: .positive, options: options, delegate: delegate)
  }
}

// MARK: - DragLeftDismissInteractiveTransition

class DragLeftDismissInteractiveTransition : InteractiveTransition {
  
  init?(interactiveViews: [UIView], options: [InteractiveTransition.Option] = [], delegate: InteractiveTransitionDelegate? = nil) {
    super.init(interactiveViews: interactiveViews, axis: .x, direction: .negative, options: options, delegate: delegate)
  }
}

// MARK: - DragRightDismissInteractiveTransition

class DragRightDismissInteractiveTransition : InteractiveTransition {
  
  init?(interactiveViews: [UIView], options: [InteractiveTransition.Option] = [], delegate: InteractiveTransitionDelegate? = nil) {
    super.init(interactiveViews: interactiveViews, axis: .x, direction: .positive, options: options, delegate: delegate)
  }
}
