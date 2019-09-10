//
//  SearchPhotosProtocols.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import Foundation

protocol SearchPhotosWorkerLogic {
    func searchPhotos(searchTerm: String, completion: @escaping (Result<[Photo], DSError>) -> Void)
    func fetchNextPhotos(searchTerm: String, page: Int, completion: @escaping (Result<[Photo], DSError>) -> Void)
}
