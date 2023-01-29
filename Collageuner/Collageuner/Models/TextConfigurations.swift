//
//  TextConfigurations.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

import RealmSwift

class TextConfiguration {
    var textsAdded: [String]?
    var currentFont: String
//    var fontsStored: [String] -> ViewModel 에서!
    
    init(textsAdded: [String]? = nil, currentFont: String) {
        self.textsAdded = textsAdded
        self.currentFont = currentFont
    }
}
