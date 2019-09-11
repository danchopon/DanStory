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
    var numberOfColumns: Int = 2
    
    // MARK: - Views
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        return refresh
    }()
    
    lazy var flowLayout: CustomCollectionViewLayout = {
        let flowLayout = CustomCollectionViewLayout()
        flowLayout.delegate = self
        flowLayout.numberOfColumns = numberOfColumns
        return flowLayout
    }()
    
    private lazy var photosList: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseID)
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    // MARK: - View Lifecycle
    
    init(viewModel: PhotosBusinessLogic) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadPhotos()
    }
    
    // MARK: Setup
    
    private func setup() {
        setupViews()
        setupConstraints()
        setupNavigationBar()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(photosList)
    }
    
    private func setupConstraints() {
        photosList.fillSuperview()
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    }
    
    private func loadPhotos() {
        loadingView.isHidden = false
        loadingView.startAnimating()
        viewModel.fetchPhotos(orderBy: .latest)
    }
    
    func displayPhotos() {
        refreshControl.endRefreshing()
        loadingView.stopAnimating()
        loadingView.isHidden = true
        photosList.reloadData()
    }
    
    func displayError(_ error: String) {
        photosList.isHidden = true
        loadingView.stopAnimating()
        loadingView.isHidden = true
        let alertController = UIAlertController(title: error, message: nil, preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            self.photosList.isHidden = false
            self.loadPhotos()
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            
        }
        alertController.addAction(retryAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func refreshTable() {
        viewModel.fetchPhotos(orderBy: .latest)
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout & UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseID, for: indexPath) as? PhotosCell else {
            fatalError("\(PhotosCell.self) not registered")
        }
        let photo = viewModel.getPhoto(for: indexPath.item)
        cell.onBind(photo)
        return cell
    }
}

extension PhotosViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        
        let imageWidth = viewModel.getPhoto(for: indexPath.item).width
        let imageHeight = viewModel.getPhoto(for: indexPath.item).height
        
        let ratio = CGFloat(imageHeight) / CGFloat(imageWidth)
        
        let newHeight = width * ratio
        return CGFloat(newHeight)
    }
}
