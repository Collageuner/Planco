//
//  Profile.swift
//  Collageuner
//
//  Created by KYUBO A. SHIM on 2023/01/25.
//

import UIKit

class Profile {
    let userUUID: String
    var userProfileImage: UIImage
    /// Other variables are TBD.
    init(userUUID: String, userProfileImage: UIImage) {
        self.userUUID = userUUID
        self.userProfileImage = userProfileImage
    }
}
