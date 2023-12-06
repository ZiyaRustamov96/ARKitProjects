//
//  SCNSceneExtensions.swift
//  Vehicle
//
//  Created by Ziya Rustamov on 16.10.23.
//

import Foundation
import ARKit

extension SCNScene {
    static func getScene() -> SCNScene? {
        SCNScene(named: String.carScene)
    }
}

private extension String {
    static let carScene = "Car-Scene.scn"
}
