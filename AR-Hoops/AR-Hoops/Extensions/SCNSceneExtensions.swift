//
//  SCNSceneExtensions.swift
//  AR-Hoops
//
//  Created by Ziya Rustamov on 30.11.23.
//

import ARKit

extension SCNScene {
    static func getScene() -> SCNScene {
        SCNScene(named: String.basketballScene) ?? SCNScene()
    }
}

private extension String {
    static let basketballScene = "Basketball.scnassets/Basketball.scn"
}
