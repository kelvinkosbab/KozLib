//
//  TopKnobVisualEffectView.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/17/18.
//  Copyright © 2018 Kozinga. All rights reserved.
//

import UIKit

class TopKnobVisualEffectView : UIVisualEffectView {
  
  // MARK: - Static Accessors
  
  static func newView() -> TopKnobVisualEffectView {
    return UINib(nibName: "TopKnobVisualEffectView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TopKnobVisualEffectView
  }
  
  // MARK: - Properties
  
  @IBOutlet weak var knobVisualEffectView: UIVisualEffectView!
  @IBOutlet weak var containerView: UIView!
  
  static let topKnobSpace: CGFloat = 5
  static let knobHeight: CGFloat = 3
  static let bottomKnobSpace: CGFloat = 10
  static let knobWidth: CGFloat = 40
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if self.knobVisualEffectView.layer.cornerRadius != TopKnobVisualEffectView.knobHeight / 2 {
      self.knobVisualEffectView.layer.cornerRadius = TopKnobVisualEffectView.knobHeight / 2
    }
  }
}
