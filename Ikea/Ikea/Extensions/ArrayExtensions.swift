//
//  ArrayExtensions.swift
//  Ikea
//
//  Created by Ziya Rustamov on 13.10.23.
//

import Foundation

extension Array {
    subscript (safeIndex index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
