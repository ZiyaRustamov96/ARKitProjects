//
//  Node.swift
//  AR-Portal
//
//  Created by Ziya Rustamov on 22.11.23.
//

import Foundation
import UIKit

enum Node {
    case top
    case bottom
    case sideA
    case sideB
    case backWall
    case sideDoorA
    case sideDoorB
    
    var nodeName: String {
        switch self {
        case .top:
            "roof"
        case .bottom:
            "floor"
        case .sideA:
            "sideWallA"
        case .sideB:
            "sideWallB"
        case .backWall:
            "backWall"
        case .sideDoorA:
            "sideDoorA"
        case .sideDoorB:
            "sideDoorB"
        }
    }
    
    var maskName: String {
        "mask"
    }
    
    var image: UIImage {
        switch self {
        case .top:
            UIImage.top!
        case .bottom:
            UIImage.bottom!
        case .sideA:
            UIImage.sideA!
        case .sideB:
            UIImage.sideB!
        case .backWall:
            UIImage.backWall!
        case .sideDoorA:
            UIImage.sideDoorA!
        case .sideDoorB:
            UIImage.sideDoorB!
        }
    }
}
