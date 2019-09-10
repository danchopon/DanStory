//
//  SearchPhotosApi.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

public enum SearchPhotosApi {
    case search(Parameters)
    case next(Parameters)
}

extension SearchPhotosApi: EndPointType {
    var constructedURL: String {
        return Constants.Network.unsplashBaseUrl
    }
    
    var path: String {
        switch self {
        case .search, .next:
            return "/search/photos"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .search, .next:
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
        case .next(let urlSearchParameters):
            return .requestParameters(bodyParameters: nil, urlParameters: urlSearchParameters)
        }
    }
}
