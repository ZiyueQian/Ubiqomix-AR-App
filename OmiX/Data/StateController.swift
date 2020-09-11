//
//  StateController.swift
//  OmiX
//
//  Created by Monsurat Olaosebikan on 6/18/19.
//  Copyright © 2019 Wellesley HCI. All rights reserved.
//

import Foundation
import ARKit

class StateController {
    static let shared = StateController()
    private init(){}

    var selectedSample = Datum(location: "", name: "", date: "", type: "", amount: nil, level: nil, risk: nil, filters: [], details: [], tip: nil, risk2: nil, image: nil, identities: nil, subtype: nil, tipImage: nil, bacteriaCounts: [])
    
//    var filters = ["surfaces": false,
//                   "objects": false,
//                   "pollen": false,
//                   "e coli": false,
//                   "dustmites": false,
//                   "peanut": false,
//                   "shellfish": false,
//                   "wheat": false,
//                   "gluten": false,
//                   "mold": false,
//                   "fish": false]
    
    var filters = Set<String>()
    
    var allSelected = [true, true]
    
    var nodes: [String: Datum] = [:]
    
    
    var tappedNode: String = ""
}
