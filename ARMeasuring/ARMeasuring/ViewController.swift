//
//  ViewController.swift
//  ARMeasuring
//
//  Created by Ziya Rustamov on 19.10.23.
//

import ARKit
import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    private let configuration = ARWorldTrackingConfiguration()
    private var startingPosition: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScene()
        configureTapGestureRecognizer()
    }

    private func configureTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureScene() {
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        sceneView.session.run(configuration)
        sceneView.delegate = self
    }
    
    private func getFormattedDistance(from value: Float) -> String {
         String(format: "%2.f", value) + "m"
    }
    
    /// Function for getting diagonal distance travelled
    private func distanceTravelled(x: Float, y: Float, z: Float) -> Float {
        (sqrtf(x*x + y*y + z*z))
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        guard let currentFrame = sceneView.session.currentFrame else { return }
        if startingPosition != nil {
            startingPosition?.removeFromParentNode()
            startingPosition = nil
            return
        }
        let camera = currentFrame.camera
        let transform = camera.transform
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.z = -0.1
        var modifiedMatrix = simd_mul(transform, translationMatrix)
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.005))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        sphere.simdTransform = modifiedMatrix
        sceneView.scene.rootNode.addChildNode(sphere)
        startingPosition = sphere
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let startingPosition = startingPosition else { return }
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let location = SCNVector3(x: transform.m41, y: transform.m42, z: transform.m43)
        let xDistance = location.x - startingPosition.position.x
        let yDistance = location.y - startingPosition.position.y
        let zDistance = location.z - startingPosition.position.z
        let distanceTravelled = distanceTravelled(x: xDistance, y: yDistance, z: zDistance)
        
        DispatchQueue.main.async {
            self.xLabel.text = self.getFormattedDistance(from: xDistance)
            self.yLabel.text = self.getFormattedDistance(from: yDistance)
            self.zLabel.text = self.getFormattedDistance(from: zDistance)
            self.distance.text = self.getFormattedDistance(from: distanceTravelled)
        }
    }
}
