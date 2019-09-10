//
//  PhotosProtocols.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

protocol PhotosDisplayLogic {
    var viewModel: PhotosBusinessLogic { get set }
    
    func displayPhotos()
    func displayError(_ error: String)
}

protocol PhotosBusinessLogic {
    var view: PhotosDisplayLogic? { get set }
    var photos: [Photo] { get set }
    var worker: PhotosWorkerLogic { get set }
    
    func fetchPhotos(orderBy: OrderByFilter, page: Int)
    func searchPhotos(searchTerm: String, page: Int)
}
