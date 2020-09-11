//
//  InfoBox.swift
//  OmiX
//
//  Created by Monsurat Olaosebikan on 6/21/19.
//  Copyright © 2019 Wellesley HCI. All rights reserved.
//

import UIKit

class InfoBox: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    static func fromNib() -> UIView {
        let view = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.first as! UIView
//        view.frame.size = CGSize(width: 340, height: 80)
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12
        backgroundColor = UIColor.white.withAlphaComponent(1)
    }
    
    func set(name: String, title: String, details: String) {
        nameLabel.text = name
        titleLabel.text = title
        detailsLabel.text = details
        layoutIfNeeded()
    }

}
