//
//  Profile.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

import RealmSwift

class Profile: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var userName: String
    @Persisted var userProfileImage: String
    /// Other variables are TBD.
    
    convenience init(userName: String, userProfileImage: String) {
        self.init()
        
        self.userName = userName
        self.userProfileImage = userProfileImage
    }
}
