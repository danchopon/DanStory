//
//  Photo.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let width: Int
    let height: Int
    let likes: Int
    let description: String?
    let urls: [URLKind.RawValue: String]
    let user: User?
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
