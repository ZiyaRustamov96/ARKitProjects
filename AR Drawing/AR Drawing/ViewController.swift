//
//  ViewController.swift
//  AR Drawing
//
//  Created by Ziya Rustamov on 09.10.23.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var draw: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScene()
    }

    private func configureScene() {
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        sceneView.showsStatistics = true
        sceneView.session.run(configuration)
        sceneView.delegate = self
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let orientation = SCNVector3(x: -transform.m31, y: -transform.m32, z: -transform.m33)
        let location = SCNVector3(x: transform.m41, y: transform.m42, z: transform.m43)
        let frontOfCamera = orientation + location
    
        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = frontOfCamera
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
            } else {
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.name = "pointer"
                pointer.position = frontOfCamera
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.enumerateChildNodes { node, _ in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                }
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
        }
    }
}

