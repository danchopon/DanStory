//
//  PhotosNetworkManager.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

class PhotosNetworkManager: NetworkManager {
    private let router = Router<PhotosApi>()
    
    func fetchPhotos(with params: Parameters, completion: @escaping (Result<[Photo], DSError>) -> Void) {
        fetch(endPoint: .photoList(params), completion: completion)
    }
    
    func searchPhotos(with params: Parameters, completion: @escaping (Result<[Photo], DSError>) -> Void) {
        fetch(endPoint: .search(params), completion: completion)
    }
    
    private func fetch(endPoint: PhotosApi, completion: @escaping (Result<[Photo], DSError>) -> Void) {
        router.request(endPoint) { data, response, error in
            if error != nil {
                completion(.failure(.network))
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let apiResponse = try JSONDecoder().decode([Photo].self, from: responseData)
                        completion(.success(apiResponse))
                    } catch let error as DecodingError {
                        self.decodingError(error)
                        completion(.failure(.network))
                    } catch {
                        completion(.failure(.network))
                    }
                case .failure(let networkFailureError):
                    completion(.failure(networkFailureError))
                }
            }
        }
    }
}
