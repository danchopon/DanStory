//
//  FilterViewCell.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/12/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import UIKit

protocol FilterViewCellDelegate: class {
    func didSelectItem(options: (String, Int))
}

class FilterViewCell: UICollectionViewCell {
    static let reuseID = String(describing: self)
    
    weak var delegate: FilterViewCellDelegate?
    
    override var isSelected: Bool {
        didSet {
            nameLabel.textColor = isSelected ?
                UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0) /* #333333 */ :
                UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1.0) /* #a9a9a9 */
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ?
                UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0) /* #dcdcdc */ :
                UIColor.white
        }
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1.0) /* #a9a9a9 */
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
        addSubview(nameLabel)
        nameLabel.fillSuperview(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
    }
    
    func configure(text: String, isActive: Bool) {
        self.nameLabel.text = text
        if isActive {
            self.nameLabel.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0) /* #333333 */
        }
    }
}
