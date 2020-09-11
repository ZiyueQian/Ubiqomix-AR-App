//
//  Allergen2InfoBox.swift
//  OmiX
//
//  Created by WellesleyHCI Lab11 on 7/11/19.
//  Copyright © 2019 Wellesley HCI. All rights reserved.
//

import Foundation
import UIKit

class Allergen2InfoBox: UIView {
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var allergenIcon: UIImageView!
    @IBOutlet weak var allergen2Icon: UIImageView!
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
    
    func set(name: String, imageName: String, image2Name: String, details: String) {
        nameLabel.text = name
        allergenIcon.image = UIImage(named: imageName)
        allergen2Icon.image = UIImage(named: image2Name)
        allergenLabel.text = details
        layoutIfNeeded()
        print(name)
        print(details)
    }
    
}

