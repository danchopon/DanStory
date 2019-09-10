//
//  PhotosApi.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

public enum PhotosApi {
    case search(Parameters)
    case photoList(Parameters)
}

extension PhotosApi: EndPointType {
    var constructedURL: String {
        return Constants.Network.unsplashBaseUrl
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search/photos"
        case .photoList:
            return "/photos"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .search, .photoList:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        var headers = HTTPHeaders()
        headers["Authorization"] = Constants.Network.unsplashAuthorizationClientId
        return headers
    }
    
    var task: HTTPTask {
        switch self {
        case .search(let urlSearchParameters):
            return .requestParameters(bodyParameters: nil, urlParameters: urlSearchParameters)
        case .photoList(let photoParameters):
            return .requestParameters(bodyParameters: nil, urlParameters: photoParameters)
        }
    }
}
