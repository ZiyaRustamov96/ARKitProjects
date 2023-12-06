//
//  ViewController.swift
//  World Tracking
//
//  Created by Ziya Rustamov on 04.10.23.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScene()
    }
    
    @IBAction func add(_ sender: Any) {
        configureNode()
    }
    
    @IBAction func reset(_ sender: Any) {
        restartSession()
    }
    
    private func configureScene() {
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        sceneView.session.run(configuration)
        sceneView.autoenablesDefaultLighting = true
    }
    
    //MARK: - Commented code is kept because during lecture new code is added, and I would like to show the learning path, that's why I keep commented code for education purposes only.
    private func configureNode() {
//        let cylinder = SCNNode(geometry: SCNCylinder(radius: 0.1, height: 0.1))
//        cylinder.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        cylinder.position = SCNVector3(x: .zero, y: .zero, z: -0.3)
//        cylinder.eulerAngles = SCNVector3(x: .zero, y: 90.degreesToRadians, z: .zero)
//        cylinder.eulerAngles = SCNVector3(x: .zero, y: .zero, z: 90.degreesToRadians)
//        sceneView.scene.rootNode.addChildNode(cylinder)
        
//        let plane = SCNNode(geometry: SCNPlane(width: 0.1, height: 0.1))
//        plane.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        plane.position = SCNVector3(x: .zero, y: .zero, z: -0.3)
//        plane.eulerAngles = SCNVector3(x: .zero, y: 90.degreesToRadians, z: .zero)
//        plane.eulerAngles = SCNVector3(x: -90.degreesToRadians, y: .zero, z: .zero)
//        sceneView.scene.rootNode.addChildNode(plane)
//        
//        let pyramid = SCNNode(geometry: SCNPyramid(width: 0.1, height: 0.1, length: 0.1))
//        pyramid.geometry?.firstMaterial?.diffuse.contents = UIColor.red
//        pyramid.position = SCNVector3(x: .zero, y: .zero, z: -0.5)
//        cylinder.addChildNode(pyramid)
//        plane.addChildNode(pyramid)
        
//        cylinder.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        cylinder.position = SCNVector3(x: .zero, y: .zero, z: -0.3)
//        cylinder.eulerAngles = SCNVector3(x: 90.degreesToRadians, y: .zero, z: .zero)
//        sceneView.scene.rootNode.addChildNode(cylinder)
//        
//        let pyramid = SCNNode(geometry: SCNPyramid(width: 0.1, height: 0.1, length: 0.1))
//        pyramid.geometry?.firstMaterial?.diffuse.contents = UIColor.red
//        pyramid.position = SCNVector3(x: .zero, y: .zero, z: -0.5)
//        cylinder.addChildNode(pyramid)
        
        //        let cylinder = SCNNode(geometry: SCNCylinder(radius: 0.1, height: 0.3))
        //        cylinder.eulerAngles = SCNVector3(x: .zero, y: .zero, z: 90.degreesToRadians)
        //        let node = SCNNode(geometry: SCNPlane(width: 0.3, height: 0.3))
        //        node.eulerAngles = SCNVector3(x: 180.degreesToRadians, y: .zero, z: .zero)
        //        node.eulerAngles = SCNVector3(x: .zero, y: 90.degreesToRadians, z: .zero)
//        let pyramid = SCNNode(geometry: SCNPyramid(width: 0.1, height: 0.1, length: 0.1))
//        pyramid.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        pyramid.position = SCNVector3(.zero, .zero, -0.3)
//        pyramid.eulerAngles = SCNVector3(x: 180.degreesToRadians, y: .zero, z: .zero)
//        sceneView.scene.rootNode.addChildNode(pyramid)
//        let doorNode = SCNNode(geometry: SCNPlane(width: 0.03, height: 0.06))
//        doorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
//        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: .zero))
//        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        let node = SCNNode()
//        node.geometry = SCNTorus(ringRadius: 0.4, pipeRadius: 0.1)
        node.position = SCNVector3(x: .zero, y: -1, z: -0.3)
        node.geometry = SCNCylinder(radius: 0.2, height: 0.6)
//        node.geometry = SCNPyramid(width: 0.2, height: 0.2, length: 0.1)
//        node.position = SCNVector3(0.2, 0.3, -0.2)
//        node.geometry?.firstMaterial?.specular.contents = UIColor.orange
//        node.eulerAngles = SCNVector3(x: .zero, y: -90.degreesToRadians, z: .zero)
//        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
//        boxNode.position = SCNVector3(.zero, -0.05, .zero)
//        doorNode.position = SCNVector3(x: .zero, y: -0.02, z: 0.053)
        sceneView.scene.rootNode.addChildNode(node)
//        node.addChildNode(boxNode)
//        boxNode.addChildNode(doorNode)
        //        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        //        let cylinderNode = SCNNode(geometry: SCNCylinder(radius: 0.05, height: 0.05))
        //        cylinderNode.position = SCNVector3(-0.3, 0.2, -0.3)
        //        cylinderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        //
        //        node.addChildNode(cylinderNode)
        //        let node = SCNNode()
        //        sceneView.scene.rootNode.addChildNode(cylinderNode)
        
        //        cylinderNode.position = SCNVector3(-0.1, 0.5, -0.5)
        //        let node = SCNNode()
        //        let path = UIBezierPath()
        //        path.move(to: .zero)
        //        path.addLine(to: CGPoint(x: .zero, y: 0.2))
        //        path.addLine(to: CGPoint(x: 0.2, y: 0.3))
        //        path.addLine(to: CGPoint(x: 0.4, y: 0.2))
        //        path.addLine(to: CGPoint(x: 0.4, y: .zero))
        //        let shape = SCNShape(path: path, extrusionDepth: 0.2)
        //        node.geometry = shape
        
        //        node.position = SCNVector3(.zero, .zero, -0.7)
        //        node.geometry = SCNPlane(width: 0.2, height: 0.2)
                
        //        node.geometry = SCNTube(innerRadius: 0.1, outerRadius: 0.2, height: 0.3)
                
        //        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
        //        node.geometry = SCNCapsule(capRadius: 0.1, height: 0.3)
        //        node.geometry = SCNCone(topRadius: 0.1, bottomRadius: 0.1, height: 0.3)
        //        node.geometry = SCNCylinder(radius: 0.2, height: 0.2)
        //        node.geometry = SCNSphere(radius: 0.2)
        //        node.position = SCNVector3(x: generateCoordinates().x, y: generateCoordinates().y, z: generateCoordinates().z)
    }
    
    private func restartSession() {
        sceneView.session.pause()
        
        sceneView.scene.rootNode.enumerateChildNodes { node, _ in
            node.removeFromParentNode()
        }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func generateCoordinates() -> (x: Float, y: Float, z: Float) {
        let x = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        let y = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        let z = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        
        return (x: x, y: y, z: z)
    }
    
    private func randomNumbers(firstNum: Float, secondNum: Float) -> Float {
        let random = Float(arc4random() / UINT32_MAX)
        let absValue = abs(firstNum - secondNum)
        let minValue = min(firstNum, secondNum)
        
        return random * absValue + minValue
    }
}

