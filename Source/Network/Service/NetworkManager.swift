//
//  NetworkManager.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/9/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

protocol NetworkManager {
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Int, DSError>
    func decodingError(_ error: DecodingError)
}

extension NetworkManager {
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Int, DSError> {
        switch response.statusCode {
        case 200...299: return .success(response.statusCode)
        default: return .failure(.network)
        }
    }
    
    func decodingError(_ error: DecodingError) {
        //TODO: Analytics
        switch error {
        case .dataCorrupted(let context):
            print("Data corrupted")
            print(context.debugDescription)
            print(context.codingPath)
        case .keyNotFound(let key, let context):
            print("Key not found")
            print(key.debugDescription)
            print(context.debugDescription)
            print(context.codingPath)
        case .typeMismatch(let type, let context):
            print("Type mismatch")
            print(type)
            print(context.debugDescription)
            print(context.codingPath)
        case .valueNotFound(let type, let context):
            print("Value not found")
            print(type)
            print(context.debugDescription)
            print(context.codingPath)
        default:
            print("Default")
            print(error.localizedDescription)
        }
    }
}
