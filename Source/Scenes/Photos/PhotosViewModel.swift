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
    var orderBy: OrderByFilter = .latest
    
    private var lastPage = 0
    private var isLoadingNext = false
    
    private var startOffset = 0
    private var endOffset = 0
    
    // MARK: - Init
    
    init(worker: PhotosWorkerLogic) {
        self.photos = [Photo]()
        self.worker = worker
    }
    
    // MARK: - BusinessLogic
    
    func fetchPhotos() {
        lastPage = 1
        startOffset = 0
        endOffset = 0
        worker.fetchPhotos(orderBy: orderBy) { result in
            switch result {
            case .success(let photos):
                self.photos = photos
                self.endOffset = photos.count
                self.view?.displayPhotos()
            case .failure(let error):
                self.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    func getPhoto(for index: Int) -> Photo {
        return photos[index]
    }
    
    func fetchNextPhotos() {
        lastPage += 1
        if isLoadingNext {
            return
        }
        
        isLoadingNext = true
        worker.fetchNextPhotos(orderBy: self.orderBy, page: lastPage) { result in
            self.isLoadingNext = false
            switch result {
            case .success(let photos):
                self.startOffset += photos.count
                self.endOffset += photos.count
                self.photos += photos
                print(self.photos.count)
                self.view?.displayNextPhotos(start: self.startOffset, end: self.endOffset)
            case .failure(let error):
                self.view?.displayError(error.localizedDescription)
            }
        }
    }
}
