//
//  PhotosWorkerLogic.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

enum OrderByFilter: String {
    case latest, oldest, popular
    
    var description: String {
        return String(describing: self)
    }
}

protocol PhotosWorkerLogic {
    func fetchPhotos(orderBy: OrderByFilter, page: Int, completion: @escaping (Result<[Photo], DSError>) -> Void)
    func searchPhotos(searchTerm: String, page: Int, completion: @escaping (Result<[Photo], DSError>) -> Void)
}
