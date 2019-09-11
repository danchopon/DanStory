//
//  PhotosCell.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/11/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import UIKit
import SDWebImage

class PhotosCell: UICollectionViewCell {
    static var reuseID: String {
        return String(describing: self)
    }
    
    lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.gray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        contentView.addSubview(photoImageView)
    }
    
    private func setupConstraints() {
        photoImageView.fillSuperview()
    }
    
    func onBind(_ photo: Photo) {
        let photoUrl = photo.urls["small"]
        guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
        photoImageView.sd_setImage(with: url, completed: nil)
    }
}
