//
//  PhotosApi.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

public enum PhotosApi {
    case photoList(Parameters)
    case next(Parameters)
}

extension PhotosApi: EndPointType {
    var constructedURL: String {
        return Constants.Network.unsplashBaseUrl
    }
    
    var path: String {
        switch self {
        case .photoList, .next:
            return "/photos"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .photoList, .next:
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
        case .photoList(let photoParameters):
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: photoParameters, additionalHeaders: headers)
        case .next(let photoParameters):
            return .requestParameters(bodyParameters: nil, urlParameters: photoParameters)
        }
    }
}
