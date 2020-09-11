//
//  CollectionViewCell.swift
//  OmiX
//
//  Created by WellesleyHCI Lab11 on 7/1/19.
//  Copyright © 2019 Wellesley HCI. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bacName: UILabel!
    
    @IBOutlet weak var bacInfo: UILabel!

    @IBOutlet weak var riskLevelImage: UIImageView!
    
    @IBOutlet weak var riskTypeImage: UIImageView!
    
    @IBOutlet weak var microbialDiversityImage: UIImageView!
    
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
}
