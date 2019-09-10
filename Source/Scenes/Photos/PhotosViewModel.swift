//
//  PhotosViewModel.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import UIKit

class PhotosViewModel: PhotosBusinessLogic {
    
    // MARK: - Properties
    
    weak var view: PhotosDisplayLogic?
    var photos: [Photo]
    var worker: PhotosWorkerLogic
    
    // MARK: - Init
    
    init(worker: PhotosWorkerLogic) {
        self.photos = [Photo]()
        self.worker = worker
    }
    
    // MARK: - BusinessLogic
    
    func fetchPhotos(orderBy: OrderByFilter, page: Int) {
        worker.fetchPhotos(orderBy: orderBy, page: page) { result in
            switch result {
            case .success(let photos):
                self.photos = photos
                self.view?.displayPhotos()
            case .failure(let error):
                self.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    func searchPhotos(searchTerm: String, page: Int) {
        worker.searchPhotos(searchTerm: searchTerm, page: page) { result in
            switch result {
            case .success(let photos):
                self.photos = photos
                self.view?.displayPhotos()
            case .failure(let error):
                self.view?.displayError(error.localizedDescription)
            }
        }
    }   
}
