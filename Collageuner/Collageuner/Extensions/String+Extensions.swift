//
//  String+Extensions.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/23.
//

import UIKit

extension String {
    var emptyToNil: String? {
        if self.isEmpty {
            return nil
        } else {
            return self
        }
    }
}
