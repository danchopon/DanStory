//
//  PhotosProtocols.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

protocol PhotosDisplayLogic: class {
    var viewModel: PhotosBusinessLogic { get set }
    
    func displayPhotos()
    func displayError(_ error: String)
}

protocol PhotosBusinessLogic {
    var view: PhotosDisplayLogic? { get set }
    var photos: [Photo] { get set }
    var worker: PhotosWorkerLogic { get set }
    
    func fetchPhotos(orderBy: OrderByFilter)
    func fetchNextPhotos(page: Int)
    func getPhoto(for index: Int) -> Photo
}

enum OrderByFilter: String {
    case latest, oldest, popular
    
    var description: String {
        return String(describing: self)
    }
}

protocol PhotosWorkerLogic {
    func fetchPhotos(orderBy: OrderByFilter, completion: @escaping (Result<[Photo], DSError>) -> Void)
    func fetchNextPhotos(orderBy: OrderByFilter, page: Int, completion: @escaping (Result<[Photo], DSError>) -> Void)
}
