//
//  AppleMusicLargePlayerSourceProtocol.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 2/4/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

protocol AppleMusicLargePlayerSourceProtocol : class {
  var originatingFrameInWindow: CGRect { get }
  var originatingCoverImageView: UIImageView? { get }
}
