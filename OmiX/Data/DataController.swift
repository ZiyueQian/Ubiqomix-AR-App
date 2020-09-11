//
//  DataController.swift
//  OmiX
//
//  Created by WellesleyHCI Lab11 on 6/28/19.
//  Copyright © 2019 Wellesley HCI. All rights reserved.
//
//  Created by Mehmet Koca on 7/30/18.
//  Copyright © 2018 Mehmet Koca. All rights reserved.
//

import Foundation
class DataController {
    func loadJson(_ fileName: String) -> [Face]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Face].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
