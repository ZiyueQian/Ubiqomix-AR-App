//
//  Sample.swift
//  OmiX
//
//  Created by Monsurat Olaosebikan on 6/18/19.
//  Copyright © 2019 Wellesley HCI. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let samples = try? newJSONDecoder().decode(Samples.self, from: jsonData)

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let samples = try Samples(json)

import Foundation

// MARK: - Samples
struct Samples: Codable {
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let location, name, date, type: String
    let amount: String?
    let level: String?
    let risk: String?
    let filters: [String]
    let details: [Detail]
    let tip, risk2, image: String?
    let identities: [Identity]?
    let subtype, tipImage: String?
    let bacteriaCounts: [BacteriaCount]?
}

// MARK: Datum convenience initializers and mutators

extension Datum {
    func with(
        location: String? = nil,
        name: String? = nil,
        date: String? = nil,
        type: String? = nil,
        amount: String?? = nil,
        level: String?? = nil,
        risk: String?? = nil,
        filters: [String]? = nil,
        details: [Detail]? = nil,
        tip: String?? = nil,
        risk2: String?? = nil,
        image: String?? = nil,
        identities: [Identity]?? = nil,
        subtype: String?? = nil,
        tipImage: String?? = nil,
        bacteriaCounts: [BacteriaCount]?? = nil
        ) -> Datum {
        return Datum(
            location: location ?? self.location,
            name: name ?? self.name,
            date: date ?? self.date,
            type: type ?? self.type,
            amount: amount ?? self.amount,
            level: level ?? self.level,
            risk: risk ?? self.risk,
            filters: filters ?? self.filters,
            details: details ?? self.details,
            tip: tip ?? self.tip,
            risk2: risk2 ?? self.risk2,
            image: image ?? self.image,
            identities: identities ?? self.identities,
            subtype: subtype ?? self.subtype,
            tipImage: tipImage ?? self.tipImage,
            bacteriaCounts: bacteriaCounts ?? self.bacteriaCounts
        )
    }
}

// MARK: - BacteriaCount
struct BacteriaCount: Codable {
    let taxon, parent, count, countNorm: Int
    let taxName, taxRank: String
    
    enum CodingKeys: String, CodingKey {
        case taxon, parent, count
        case countNorm = "count_norm"
        case taxName = "tax_name"
        case taxRank = "tax_rank"
    }
}

// MARK: - Detail
struct Detail: Codable {
    let title, info: String
    let level, risk, diversity: String?
}


// MARK: - Identity
struct Identity: Codable {
    let scientificName: String?
    let name, percentage: String
    let danger: String?
    
    enum CodingKeys: String, CodingKey {
        case scientificName = "scientific_name"
        case name, percentage, danger
    }
}
