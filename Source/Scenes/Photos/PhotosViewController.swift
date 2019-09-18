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
    private var numberOfColumns: Int = 1
    
    // MARK: - Views
    
    private let slideMenu = FilterSlideMenu()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        return refresh
    }()
    
    private lazy var flowLayout: CustomCollectionViewLayout = {
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
        slideMenu.delegate = self
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
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    private func loadPhotos() {
        loadingView.isHidden = false
        loadingView.startAnimating()
        viewModel.fetchPhotos()
    }
    
    func displayPhotos() {
        refreshControl.endRefreshing()
        loadingView.stopAnimating()
        loadingView.isHidden = true
        photosList.reloadData()
    }
    
    func displayNextPhotos(start: Int, end: Int) {
        var insertingIndexes = [IndexPath]()
        for index in start..<end {
            insertingIndexes.append(IndexPath(row: index, section: 0))
        }
        
        photosList.performBatchUpdates({
            UIView.setAnimationsEnabled(false)
            photosList.insertItems(at: insertingIndexes)
            flowLayout.prepareNew(start: start, end: viewModel.photos.count)
            photosList.collectionViewLayout.invalidateLayout()
            photosList.reloadData()
        }, completion: { _ in
            UIView.setAnimationsEnabled(true)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photosList.collectionViewLayout.invalidateLayout()
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
        viewModel.fetchPhotos()
    }
    
    @objc private func addBarButtonTapped() {
        slideMenu.showMenu()
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.photos.count - 1 {
            viewModel.fetchNextPhotos()
        }
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

extension PhotosViewController: SlideMenuDelegate {
    func changeOrderByFilter(orderBy: OrderByFilter) {
        viewModel.orderBy = orderBy
        loadPhotos()
    }
    
    func changeNumberOfColumns(number: ViewLayoutSetting) {
        if numberOfColumns == number.option { return }
        numberOfColumns = number.option
        UIView.animate(withDuration: 0.2) {
            if self.viewModel.photos.count > 0 {
                self.flowLayout.numberOfColumns = self.numberOfColumns
                self.flowLayout.invalidateLayout()
                self.photosList.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                
            }
        }
    }
}
