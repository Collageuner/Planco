//
//  Optional+Extensions.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/09.
//

import UIKit

extension String? {
    var isNilorEmpty: Bool {
        return self == nil || self == ""
    }
}
