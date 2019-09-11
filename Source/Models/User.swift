//
//  User.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

struct User: Codable {
    let id, username, name: String
    let bio: String?
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case id, username, name, bio
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small, medium, large: String
}
