//
//  PlusOperationExtensions.swift
//  AR-Hoops
//
//  Created by Ziya Rustamov on 30.11.23.
//

import Foundation
import ARKit

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
