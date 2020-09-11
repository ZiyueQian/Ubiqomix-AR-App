//
//  AllergenInfoBox.swift
//  OmiX
//
//  Created by WellesleyHCI Lab11 on 7/11/19.
//  Copyright © 2019 Wellesley HCI. All rights reserved.
//

import Foundation
import UIKit

class AllergenInfoBox: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var allergenIcon: UIImageView!
    @IBOutlet weak var allergenLabel: UILabel!
    
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
    
    func set(name: String, imageName: String, details: String) {
        nameLabel.text = name
        allergenIcon.image = UIImage(named: imageName)
        allergenLabel.text = details
        layoutIfNeeded()
    }
    
}

