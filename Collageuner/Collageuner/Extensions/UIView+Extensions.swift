//
//  UIView+Extensions.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
      for view in views {
        self.addSubview(view)
      }
    }
}
