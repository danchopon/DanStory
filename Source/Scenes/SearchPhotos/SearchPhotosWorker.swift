//
//  SearchPhotosWorker.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import UIKit

class SearchPhotosWorker: SearchPhotosWorkerLogic {
    private let searchPhotosNetworkManager = SearchPhotosNetworkManager()
    
    func searchPhotos(searchTerm: String, completion: @escaping (Result<[Photo], DSError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let parameters: Parameters = [
                "query": searchTerm,
                "page": 1,
                "per_page": 15
            ]
            self.searchPhotosNetworkManager.searchPhotos(with: parameters, completion: { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }
    
    func fetchNextPhotos(searchTerm: String, page: Int, completion: @escaping (Result<[Photo], DSError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let parameters: Parameters = [
                "query": searchTerm,
                "page": page,
                "per_page": 15
            ]
            self.searchPhotosNetworkManager.searchPhotos(with: parameters, completion: { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }
}
