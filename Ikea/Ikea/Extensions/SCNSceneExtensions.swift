//
//  SCNSceneExtensions.swift
//  Ikea
//
//  Created by Ziya Rustamov on 13.10.23.
//

import ARKit

extension SCNScene {
    static func getScene(using item: Item) -> SCNScene {
        switch item {
        case .cup:
            SCNScene(named: Item.allCases[safeIndex: 0]?.scenePath ?? "") ?? SCNScene()
        case .vase:
            SCNScene(named: Item.allCases[safeIndex: 1]?.scenePath ?? "") ?? SCNScene()
        case .boxing:
            SCNScene(named: Item.allCases[safeIndex: 2]?.scenePath ?? "") ?? SCNScene()
        case .table:
            SCNScene(named: Item.allCases[safeIndex: 3]?.scenePath ?? "") ?? SCNScene()
        }
    }
}

