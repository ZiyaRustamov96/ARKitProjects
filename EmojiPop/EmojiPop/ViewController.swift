//
//  ViewController.swift
//  EmojiPop
//
//  Created by Ziya Rustamov on 05.12.23.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet weak var hudLabel: UILabel!
    @IBOutlet var sceneView: ARSKView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        // 1
        let spawnNode = SKNode()
        spawnNode.name = "SpawnPoint"
        
        let boxNode = SKLabelNode(text: "🆘")
        boxNode.verticalAlignmentMode = .center
        boxNode.horizontalAlignmentMode = .center
        boxNode.zPosition = 100
        boxNode.setScale(1.5)
        spawnNode.addChild(boxNode)
        // 3
        return spawnNode
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        showAlert("Session Failure", error.localizedDescription)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default, handler: nil
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    func session(_ session: ARSession,
                 cameraDidChangeTrackingState camera: ARCamera) {
        // 1
        switch camera.trackingState {
        case .normal: break
        case .notAvailable:
            showAlert("Tracking Limited", "AR not available")
            break
            // 2
        case .limited(let reason):
            switch reason {
            case .initializing, .relocalizing: break
            case .excessiveMotion:
                showAlert("Tracking Limited", "Excessive motion!")
                break
            case .insufficientFeatures:
                showAlert("Tracking Limited", "Insufficient features!")
                break
            default: break
            }
        }
    }
}
