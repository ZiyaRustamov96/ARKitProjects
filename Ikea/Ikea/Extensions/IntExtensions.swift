//
//  IntExtensions.swift
//  Ikea
//
//  Created by Ziya Rustamov on 13.10.23.
//

import Foundation

extension Int {
    var degreesToRadians: CGFloat { CGFloat(Double(self) * .pi/180) }
}
