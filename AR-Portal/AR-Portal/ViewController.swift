//
//  ViewController.swift
//  AR-Portal
//
//  Created by Ziya Rustamov on 20.11.23.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var planeDetected: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScene()
        configureGestureRecognizer()
    }
    
    private func configureScene() {
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        sceneView.delegate = self
    }
    
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        let touchLocation = sender.location(in: sceneView)
        
        guard let hitTest = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .horizontal) else { return }
        let results: [ARRaycastResult] = self.sceneView.session.raycast(hitTest)
        
        guard let firstResult = results.first else { return }
        addPortal(arRaycastResult: firstResult)
    }
    
    private func addPortal(arRaycastResult: ARRaycastResult) {
        let portalScene = SCNScene.getScene()
        
        guard let portalNode = portalScene.rootNode.childNode(withName: String.portal, recursively: false) else { return }
        let transform = arRaycastResult.worldTransform
        let thirdColumn = transform.columns.3
        portalNode.position = SCNVector3(x: thirdColumn.x, y: thirdColumn.y, z: thirdColumn.z)
        sceneView.scene.rootNode.addChildNode(portalNode)
        addPlane(node: .top, portalNode: portalNode)
        addPlane(node: .bottom, portalNode: portalNode)
        addWalls(node: .backWall, portalNode: portalNode)
        addWalls(node: .sideA, portalNode: portalNode)
        addWalls(node: .sideB, portalNode: portalNode)
        addWalls(node: .sideDoorA, portalNode: portalNode)
        addWalls(node: .sideDoorB, portalNode: portalNode)
    }
    
    private func addWalls(node: Node, portalNode: SCNNode) {
        let child = portalNode.childNode(withName: node.nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = node.image
        child?.renderingOrder = 200
        
        if let mask = child?.childNode(withName: node.maskName, recursively: false) {
            mask.geometry?.firstMaterial?.transparency = 0.000001
        }
    }
    
    private func addPlane(node: Node, portalNode: SCNNode) {
        let child = portalNode.childNode(withName: node.nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = node.image
        child?.renderingOrder = 200
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        DispatchQueue.main.async {
            self.planeDetected.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.planeDetected.isHidden = true
        }
    }
}

private extension String {
    static let portal = "Portal"
}
