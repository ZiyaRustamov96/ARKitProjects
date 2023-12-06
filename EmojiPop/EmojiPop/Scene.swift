//
//  Scene.swift
//  EmojiPop
//
//  Created by Ziya Rustamov on 05.12.23.
//

import SpriteKit
import ARKit

public enum GameState {
    case Init
    case TapToStart
    case Playing
    case GameOver
}

class Scene: SKScene {
    
    var gameState = GameState.Init
    var anchor: ARAnchor?
    var emojis = "😁😂😛😝🤪😎🤓🤖🎃💀🤡"
    var spawnTime : TimeInterval = .zero
    var score : Int = .zero
    var lives : Int = 10
    
    override func didMove(to view: SKView) {
        // Setup your scene here
        startGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        guard let sceneView = self.view as? ARSKView else {
        //            return
        //        }
        //
        //        // Create anchor using the camera's current position
        //        if let currentFrame = sceneView.session.currentFrame {
        //
        //            // Create a transform with a translation of 0.2 meters in front of the camera
        //            var translation = matrix_identity_float4x4
        //            translation.columns.3.z = -0.2
        //            let transform = simd_mul(currentFrame.camera.transform, translation)
        //
        //            // Add a new anchor to the session
        //            let anchor = ARAnchor(transform: transform)
        //            sceneView.session.add(anchor: anchor)
        //        }
        
        switch gameState {
        case .Init:
            break
        case .TapToStart:
            playGame()
            break
        case .Playing:
            //checkTouches(touches)
            break
        case .GameOver:
            startGame()
            break
        }
    }
    
    private func updateHUD(_ message: String) {
        guard let sceneView = self.view as? ARSKView, let viewController = sceneView.delegate as? ViewController else {
            return
        }
        
        viewController.hudLabel.text = message
    }
    
    public func startGame() {
        gameState = .TapToStart
        updateHUD("- TAP TO START -")
        removeAnchor()
    }
    
    public func playGame() {
        gameState = .Playing
        score = 0
        lives = 10
        spawnTime = 0
        
        addAnchor()
    }
    
    public func stopGame() {
        gameState = .GameOver
        updateHUD("GAME OVER! SCORE: " + String(score))
    }
    
    private func addAnchor() {
        // 1
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        // 2
        if let currentFrame = sceneView.session.currentFrame {
            // 3
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.5
            let transform = simd_mul(currentFrame.camera.transform,
                                     translation)
            // 4
            anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor!)
        }
    }
    
    private func removeAnchor() {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        if anchor != nil {
            sceneView.session.remove(anchor: anchor!)
        }
    }
}
