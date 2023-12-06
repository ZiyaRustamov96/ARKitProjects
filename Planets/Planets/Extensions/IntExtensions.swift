//
//  IntExtensions.swift
//  Planets
//
//  Created by Ziya Rustamov on 09.10.23.
//

import Foundation

extension Int {
    var degreesToRadians: CGFloat {
        CGFloat(self) * .pi / 180
    }
}
