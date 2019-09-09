//
//  EndPointType.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/9/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

protocol EndPointType {
    var constructedURL: String { get }
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

extension EndPointType {
    var baseURL: URL {
        guard let url = URL(string: constructedURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
