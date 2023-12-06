//
//  UIImageExtensions.swift
//  AR-Portal
//
//  Created by Ziya Rustamov on 22.11.23.
//

import UIKit

extension UIImage {
    static let top = UIImage(named: "Portal.scnassets/\(ImageName.top.rawValue)")
    static let bottom = UIImage(named: "Portal.scnassets/\(ImageName.bottom.rawValue)")
    static let sideA = UIImage(named: "Portal.scnassets/\(ImageName.sideA.rawValue)")
    static let sideB = UIImage(named: "Portal.scnassets/\(ImageName.sideB.rawValue)")
    static let backWall = UIImage(named: "Portal.scnassets/\(ImageName.back.rawValue)")
    static let sideDoorA = UIImage(named: "Portal.scnassets/\(ImageName.sideDoorA.rawValue)")
    static let sideDoorB = UIImage(named: "Portal.scnassets/\(ImageName.sideDoorB.rawValue)")
}

enum ImageName: String {
    case top
    case bottom
    case sideA
    case sideB
    case back
    case sideDoorA
    case sideDoorB
}
