//
//  NetworkError.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/9/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
