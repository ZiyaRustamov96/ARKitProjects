//
//  SCNSceneExtensions.swift
//  Whack a jellyfish
//
//  Created by Ziya Rustamov on 11.10.23.
//

import ARKit

extension SCNScene {
    static let jellyFishScene = SCNScene(named: String.sceneName)
}

private extension String {
    static let sceneName = "art.scnassets/Jellyfish.scn"
}
