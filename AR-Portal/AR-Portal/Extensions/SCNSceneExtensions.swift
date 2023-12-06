//
//  SCNSceneExtensions.swift
//  AR-Portal
//
//  Created by Ziya Rustamov on 22.11.23.
//

import ARKit

extension SCNScene {
    static func getScene() -> SCNScene {
        SCNScene(named: String.portalScene) ?? SCNScene()
    }
}

private extension String {
    static let portalScene = "Portal.scnassets/Portal.scn"
}
