//
//  TaskTimeZoneSection.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/02/14.
//

import UIKit

import RxDataSources

struct TaskTimeZoneSection {
    var header: String
    var items: [Tasks]
}

extension TaskTimeZoneSection: SectionModelType {
    typealias Item = Tasks
    
    init(original: TaskTimeZoneSection, items: [Tasks]) {
        self = original
        self.items = items
    }
}
