//
//  PhotosViewController.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, PhotosDisplayLogic {
    static func instance() -> PhotosViewController {
        let worker = PhotosWorker()
        let viewModel = PhotosViewModel(worker: worker)
        let view = PhotosViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    // MARK: - Properties
    
    var viewModel: PhotosBusinessLogic
    
    // MARK: - Views
    
    // TODO: setup Views
    
    // MARK: - View Lifecycle
    
    init(viewModel: PhotosBusinessLogic) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func loadPhotos() {
        // TODO:
    }
    
    func displayPhotos() {
        // TODO:
    }
    
    func displayError(_ error: String) {
        // TODO:
    }
}
