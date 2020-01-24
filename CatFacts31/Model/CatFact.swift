//
//  CatFact.swift
//  CatFacts31
//
//  Created by Jon Corn on 1/23/20.
//  Copyright © 2020 jdcorn. All rights reserved.
//

import Foundation

// Create top level GET object
struct TopLevelGETObject: Decodable {
    let facts: [CatFact]
}

// Create top level POST object
struct TopLevelPOSTObject: Encodable {
    let fact: CatFact
}

// Create cat fact model
struct CatFact: Codable {
    let id: Int?
    let details: String
}
