//
//  DSError.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/9/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

enum DSError: Error {
    case network
    case noData
    case nilValue
    
    var localizedDescription: String {
        switch self {
        case .network:
            return "You are currently offline.\nCheck your internet connection"
        default:
            return ""
        }
    }
}
