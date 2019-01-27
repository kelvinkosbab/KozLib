//
//  UIImage+Util.swift
//  KozLibrary
//
//  Created by Kelvin Kosbab on 1/26/19.
//  Copyright © 2019 Kozinga. All rights reserved.
//

import UIKit

extension UIImage {
  
  static func download(url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
    DispatchQueue.global(qos: .background).async {
      
      guard let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) else {
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }
      
      DispatchQueue.main.async {
        completion(image)
      }
    }
  }
}
