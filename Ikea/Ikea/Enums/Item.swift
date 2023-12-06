//
//  Item.swift
//  Ikea
//
//  Created by Ziya Rustamov on 13.10.23.
//

enum Item: String, CaseIterable {
    case cup
    case vase
    case boxing
    case table
    
    var scenePath: String {
        switch self {
        case .cup:
            "Models.scnassets/cup.scn"
        case .vase:
            "Models.scnassets/vase.scn"
        case .boxing:
            "Models.scnassets/boxing.scn"
        case .table:
            "Models.scnassets/table.scn"
        }
    }
}
