//
//  DetailViewController.swift
//  OmiX
//
//  Created by Monsurat Olaosebikan on 7/1/19.
//  Copyright © 2019 Wellesley HCI. All rights reserved.
//

import UIKit

class DetailViewController: UICollectionViewController {
    
    var titleArray = [String]()
    var infoArray = [String]()
    var sampleName = String()
    var riskLevelArray = [String]()
    var riskTypeArray = [String]()
    var diversityArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
            let collectionView = collectionView {
            let w = collectionView.frame.width - 20
            flowLayout.estimatedItemSize = CGSize(width: w, height: 200)
        }
        
        sampleName = StateController.shared.nodes[StateController.shared.tappedNode]?.name ?? ""
        
        let details = StateController.shared.nodes[StateController.shared.tappedNode]?.details

        if let count = details?.count {
            for num in 0..<count {
               // var subtitle = ""
                
                
                
//                if (StateController.shared.nodes[StateController.shared.tappedNode]?.identities?[num].danger == "high") {
//                    subtitle = details?[num].title ?? ""
//                    subtitle = subtitle + " ‼️"
//                } else {
                   //subtitle =
//                }
                
                titleArray.append(details?[num].title ?? "")
                infoArray.append(details?[num].info ?? "")
                riskLevelArray.append(details?[num].level ?? "")
                riskTypeArray.append(details?[num].risk ?? "")
                diversityArray.append(details?[num].diversity ?? "")
            }
        }
        
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bacCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bacName?.text = titleArray[indexPath.row]
        cell.bacInfo?.text = infoArray[indexPath.row]
        
        
        //if level is high - will have check mark. level is low - will have 'x'.
        let riskLevelImageName = riskLevelArray[indexPath.row]
        //shows the risk (ex. e coli, peanut)
        var riskTypeImageName = riskTypeArray[indexPath.row]
        
        if riskLevelImageName == "low" {
            riskTypeImageName = "no " + riskTypeImageName
        }
        
        cell.riskLevelImage?.image = UIImage(named: riskLevelImageName)
        cell.riskTypeImage?.image = UIImage(named: riskTypeImageName)
        cell.microbialDiversityImage?.image = UIImage(named: diversityArray[indexPath.row])
        
        return cell
    }

    //link to the CollectionHeaderView class
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {       //ensuring correct element type
        case UICollectionView.elementKindSectionHeader:
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(   //dequeue header
                    ofKind: kind,
                    withReuseIdentifier: "\(CollectionHeaderView.self)",
                    for: indexPath) as? CollectionHeaderView
                else {
                    fatalError("Invalid view type")
            }
            var tip = StateController.shared.nodes[StateController.shared.tappedNode]?.tip ?? "So far so good!"
            
//            var tipImage = StateController.shared.nodes[StateController.shared.tappedNode]?.tipImage

            headerView.headerLabel?.text = "More about " + sampleName
            headerView.tipLabel?.text = tip
//            headerView.tipImage?.image = UIImage(named: tipImage ?? "placeholder")
            return headerView
        default:
            assert(false, "Invalid element type")       //ensure correct response type
        }
    }
    
}
