//
//  IntExtensions.swift
//  Floor is lava
//
//  Created by Ziya Rustamov on 12.10.23.
//

import Foundation

extension Int {
    var degreesToRadians: Float { Float(Double(self) * .pi/180) }
}
