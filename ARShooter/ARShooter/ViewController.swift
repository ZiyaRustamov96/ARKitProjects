//
//  ViewController.swift
//  ARShooter
//
//  Created by Ziya Rustamov on 01.12.23.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    private let configuration = ARWorldTrackingConfiguration()
    private let power: Float = 50.0
    private var target: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
    }
    
    private func setupScene() {
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        sceneView.session.run(configuration)
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
 
    @IBAction func addTargets(_ sender: Any) {
        addEgg(x: 5, y: .zero, z: -40)
        addEgg(x: .zero, y: .zero, z: -40)
        addEgg(x: -5, y: .zero, z: -40)
    }
    
    private func shootBullet() {
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let location = SCNVector3(x: transform.m41, y: transform.m42, z: transform.m43)
        let orientation = SCNVector3(x: -transform.m31, y: -transform.m32, z: -transform.m33)
        let position = location + orientation
        let bullet = SCNNode(geometry: SCNSphere(radius: 0.1))
        bullet.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        bullet.position = position
        bullet.physicsBody?.contactTestBitMask = BitMaskCategory.target.rawValue
        bullet.name = String.bullet
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: bullet))
        body.isAffectedByGravity = false
        bullet.physicsBody = body
        bullet.physicsBody?.categoryBitMask = BitMaskCategory.bullet.rawValue
        bullet.physicsBody?.applyForce(SCNVector3(x: orientation.x * power, y: orientation.y * power, z: orientation.z * power), asImpulse: true)
        sceneView.scene.rootNode.addChildNode(bullet)
        bullet.runAction(
            SCNAction.sequence(
                [
                    SCNAction.wait(duration: 2.0),
                    SCNAction.removeFromParentNode()
                ]
            )
        )
    }
    
    private func addEgg(x: Float, y: Float, z: Float) {
        let eggScene = SCNScene.getScene()
        guard let eggNode = eggScene.rootNode.childNode(withName: String.eggNode, recursively: false) else { return }
        eggNode.position = SCNVector3(x,y,z)
        eggNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: eggNode))
        eggNode.physicsBody?.categoryBitMask = BitMaskCategory.target.rawValue
        eggNode.physicsBody?.contactTestBitMask = BitMaskCategory.bullet.rawValue
        sceneView.scene.rootNode.addChildNode(eggNode)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        let touchLocation = sender.location(in: sceneView)
        
        guard let hitTest = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .horizontal) else { return }
        let results: [ARRaycastResult] = self.sceneView.session.raycast(hitTest)
        
        guard let firstResult = results.first else { return }
        shootBullet()
    }
    
    private func setupBulletAndEggCollision(using contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        if nodeA.physicsBody?.categoryBitMask == BitMaskCategory.target.rawValue {
            target = nodeA
        } else if nodeB.physicsBody?.categoryBitMask == BitMaskCategory.target.rawValue {
            target = nodeB
        }
        
        let confetti = SCNParticleSystem.getConfettiParticleSystem()
        confetti.loops = false
        confetti.particleLifeSpan = 4
        confetti.emitterShape = target?.geometry
        
        let confettiNode = SCNNode()
        confettiNode.addParticleSystem(confetti)
        confettiNode.position = contact.contactPoint
        
        sceneView.scene.rootNode.addChildNode(confettiNode)
        target?.removeFromParentNode()
    }
}

extension ViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        setupBulletAndEggCollision(using: contact)
    }
}

private extension String {
    static let eggNode = "egg"
    static let bullet = ""
}
