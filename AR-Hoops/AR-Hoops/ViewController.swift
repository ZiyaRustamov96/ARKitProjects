//
//  ViewController.swift
//  AR-Hoops
//
//  Created by Ziya Rustamov on 30.11.23.
//

import UIKit
import ARKit
import Each

class ViewController: UIViewController {
    
    @IBOutlet weak var planeDetected: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var power: Float = 1.0
    var basketAdded: Bool = false
    let timer = Each(0.05).seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        configureGestureRecognizer()
    }
    
    private func setupScene() {
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        sceneView.autoenablesDefaultLighting = true
        sceneView.delegate = self
    }
    
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer.cancelsTouchesInView = false
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if basketAdded {
            timer.perform {
                self.power += 1
                return .continue
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if basketAdded {
            timer.stop()
            shootBall()
        }
        
        power = 1
    }
    
    private func shootBall() {
        guard let pointOfView = sceneView.pointOfView else { return }
        removeEveryOtherBall()
        let transform = pointOfView.transform
        let location = SCNVector3(x: transform.m41, y: transform.m42, z: transform.m43)
        let orientation = SCNVector3(x: -transform.m31, y: -transform.m32, z: -transform.m33)
        let position = location + orientation
        let ball = SCNNode(geometry: SCNSphere(radius: 0.25))
        ball.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "ball")
        ball.position = position
        ball.name = String.basketball
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball))
        body.restitution = 0.2
        ball.physicsBody = body
        ball.physicsBody?.applyForce(SCNVector3(x: orientation.x * power, y: orientation.y * power, z: orientation.z * power), asImpulse: true)
        sceneView.scene.rootNode.addChildNode(ball)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        let touchLocation = sender.location(in: sceneView)
        
        guard let hitTest = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .horizontal) else { return }
        let results: [ARRaycastResult] = self.sceneView.session.raycast(hitTest)
        
        guard let firstResult = results.first else { return }
        addBasket(arRaycastResult: firstResult)
    }
    
    private func addBasket(arRaycastResult: ARRaycastResult) {
        if !basketAdded {
            let basketScene = SCNScene.getScene()
            
            guard let basketNode = basketScene.rootNode.childNode(withName: String.basket, recursively: false) else { return }
            let transform = arRaycastResult.worldTransform
            let thirdColumn = transform.columns.3
            basketNode.position = SCNVector3(x: thirdColumn.x, y: thirdColumn.y, z: thirdColumn.z)
            basketNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: basketNode, options: [.keepAsCompound: true, .type: SCNPhysicsShape.ShapeType.concavePolyhedron]))
            sceneView.scene.rootNode.addChildNode(basketNode)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.basketAdded = true
            }
        }
    }
    
    private func removeEveryOtherBall() {
        sceneView.scene.rootNode.enumerateChildNodes { node, _ in
            if node.name == String.basketball {
                node.removeFromParentNode()
            }
        }
    }
    
    deinit {
        timer.stop()
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
    static let basket = "Basket"
    static let basketball = "Basketball"
}
