//
//  ViewController.swift
//  Floor is lava
//
//  Created by Ziya Rustamov on 11.10.23.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSceneView()
    }

    private func configureSceneView() {
        configuration.planeDetection = .horizontal
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        sceneView.session.run(configuration)
        sceneView.delegate = self
    }
    
    private func createLava(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let lavaNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.planeExtent.width), height: CGFloat(planeAnchor.planeExtent.height)))
        lavaNode.geometry?.firstMaterial?.diffuse.contents = UIImage.lava
        lavaNode.geometry?.firstMaterial?.isDoubleSided = true
        lavaNode.position = SCNVector3(x: planeAnchor.center.x, y: planeAnchor.center.y, z: planeAnchor.center.z)
        lavaNode.eulerAngles = SCNVector3(x: 90.degreesToRadians, y: .zero, z: .zero)
        return lavaNode
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let lavaNode = createLava(planeAnchor: planeAnchor)
        node.addChildNode(lavaNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        node.enumerateChildNodes { childNode, _ in
            childNode.removeFromParentNode()
        }
        
        let lavaNode = createLava(planeAnchor: planeAnchor)
        node.addChildNode(lavaNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARPlaneAnchor else { return }
        
        node.enumerateChildNodes { childNode, _ in
            childNode.removeFromParentNode()
        }
    }
}

