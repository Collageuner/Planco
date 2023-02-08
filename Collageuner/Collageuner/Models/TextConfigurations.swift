//
//  TextConfigurations.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

class TextConfiguration {
//    @Persisted var textsAdded = List<String>() // VM 에서!
    var currentFont: String
//    var fontsStored: [String] -> ViewModel 에서!
    
    init(currentFont: String) {
        self.currentFont = currentFont
    }
}
