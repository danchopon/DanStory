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
}

protocol PhotosBusinessLogic {
    var view: PhotosDisplayLogic? { get set }
}
