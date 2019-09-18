//
//  FilterViewSectionHeader.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/16/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import UIKit

class FilterViewSectionHeader: UICollectionReusableView {
    static let reuseID = String(describing: self)
    
    private lazy var sectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0) /* #333333 */
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(sectionLabel)
        sectionLabel.fillSuperview(padding: UIEdgeInsets(top: 16, left: 8, bottom: 0, right: 8))
    }
    
    func configure(text: String) {
        self.sectionLabel.text = text
    }
}
