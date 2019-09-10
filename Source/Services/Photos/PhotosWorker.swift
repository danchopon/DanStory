//
//  PhotosWorker.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import UIKit

class PhotosWorker: PhotosWorkerLogic {
    private let photosNetworkManager = PhotosNetworkManager()
    
    func fetchPhotos(orderBy: OrderByFilter, page: Int, completion: @escaping (Result<[Photo], DSError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let parameters: Parameters = [
                "page": page,
                "per_page": 15,
                "order_by": orderBy
            ]
            self.photosNetworkManager.fetchPhotos(with: parameters, completion: { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }
    
    func searchPhotos(searchTerm: String, page: Int, completion: @escaping (Result<[Photo], DSError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let parameters: Parameters = [
                "query": searchTerm,
                "page": page,
                "per_page": 15
            ]
            self.photosNetworkManager.searchPhotos(with: parameters, completion: { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            })
        }
    }
}
