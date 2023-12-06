//
//  ViewController.swift
//  Whack a jellyfish
//
//  Created by Ziya Rustamov on 10.10.23.
//

import UIKit
import ARKit
import Each

class ViewController: UIViewController {
    var timer = Each(1).seconds
    var countdown = 10
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScene()
        setupTapGestureRecognizer()
    }
    
    private func configureScene() {
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        sceneView.session.run(configuration)
    }
    
    @IBAction func play(_ sender: Any) {
        setTimer()
        addNode()
        play.isEnabled = false
    }
    
    @IBAction func reset(_ sender: Any) {
        timer.stop()
        restoreTimer()
        play.isEnabled = true
        sceneView.scene.rootNode.enumerateChildNodes { node, _ in
            node.removeFromParentNode()
        }
    }
    
    private func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addNode() {
        let jellyFishScene = SCNScene.jellyFishScene
        guard let jellyFishNode = jellyFishScene?.rootNode.childNode(withName: String.jellyfishNodeName, recursively: false) else { return }
        let randomXPosition = randomNumbers(firstNum: -1, secondNum: 1)
        let randomYPosition = randomNumbers(firstNum: -0.5, secondNum: 0.5)
        let randomZPosition = randomNumbers(firstNum: -1, secondNum: 1)
        jellyFishNode.position = SCNVector3(x: randomXPosition, y: randomYPosition, z: randomZPosition)
        sceneView.scene.rootNode.addChildNode(jellyFishNode)
    }
    
    private func animateNode(node: SCNNode) {
        let spin = CABasicAnimation(keyPath: String.positionAnimationName)
        spin.fromValue = node.presentation.position // Presentation represents current state of object inside of the scene view, shortly said, current position of the object in the scene view.
        spin.toValue = SCNVector3(x: node.presentation.position.x - 0.2, y: node.presentation.position.y - 0.2, z: node.presentation.position.z - 0.2)
        spin.duration = 0.07
        spin.repeatCount = 5
        spin.autoreverses = true
        node.addAnimation(spin, forKey: String.positionAnimationName)
    }
    
    
    private func randomNumbers(firstNum: Float, secondNum: Float) -> Float {
        let random = Float(arc4random() / UINT32_MAX)
        let absValue = abs(firstNum - secondNum)
        let minValue = min(firstNum, secondNum)
        
        return random * absValue + minValue
    }

    private func setTimer() {
        timer.perform {
            self.countdown -= 1
            self.timerLabel.text = String(self.countdown)
            if self.countdown == .zero {
                self.timerLabel.text = "You lose"
                return .stop
            }
            return .continue
        }
    }
    
    private func restoreTimer() {
        countdown = 10
        timerLabel.text = String(countdown)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneViewTappedOn = sender.view as? SCNView else { return }
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        
        guard countdown > .zero, let results = hitTest.first else { return }

        let node = results.node
        if node.animationKeys.isEmpty {
            SCNTransaction.begin()
            animateNode(node: node)
            SCNTransaction.completionBlock = {
                node.removeFromParentNode()
                self.addNode()
                self.restoreTimer()
            }
            SCNTransaction.commit()
        }
    }
}

private extension String {
    static let jellyfishNodeName = "Jellyfish"
    static let positionAnimationName = "position"
}
