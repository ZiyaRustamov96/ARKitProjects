//
//  SCNParticleSystemExtensions.swift
//  ARShooter
//
//  Created by Ziya Rustamov on 01.12.23.
//

import Foundation
import ARKit

extension SCNParticleSystem {
    static func getConfettiParticleSystem() -> SCNParticleSystem {
        guard let particleSystem = SCNParticleSystem(named: String.confetti, inDirectory: nil) else { return SCNParticleSystem() }
        return particleSystem
    }
}

private extension String {
    static let confetti = "Media.scnassets/Confetti.scnp"
}
