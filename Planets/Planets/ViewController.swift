//
//  ViewController.swift
//  Planets
//
//  Created by Ziya Rustamov on 09.10.23.
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureSunNode()
        configurePlanets()
    }

    private func configureScene() {
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        sceneView.session.run(configuration)
        sceneView.autoenablesDefaultLighting = true
    }
    
    private func configurePlanets() {
        let earth = planet(
            withRadius: 0.2,
            diffuse: .earthDay,
            specular: .earthSpecular,
            emission: .earthEmission,
            normal: .earthNormal,
            position: SCNVector3(x: 1.2, y: .zero, z: .zero)
        )
        let venus = planet(
            withRadius: 0.1,
            diffuse: .venusSurface,
            specular: nil,
            emission: .venusAtmosphere,
            normal: nil,
            position: SCNVector3(x: 0.7, y: .zero, z: .zero)
        )
        let moon = planet(
            withRadius: 0.05,
            diffuse: .moonDiffuse,
            specular: nil,
            emission: nil,
            normal: nil,
            position: SCNVector3(x: .zero, y: .zero, z: -0.3)
        )
        
        let earthParent = SCNNode()
        let venusParent = SCNNode()
        let moonParent = SCNNode()
        
        earthParent.position = SCNVector3(x: .zero, y: .zero, z: -1)
        venusParent.position = SCNVector3(x: .zero, y: .zero, z: -1)
        moonParent.position = SCNVector3(x: 1.2, y: .zero, z: .zero)
        
        rotate(planet: earthParent, with: 14)
        rotate(planet: venusParent, with: 10)
        rotate(planet: moonParent, with: 5)
        rotate(planet: earth)
        rotate(planet: venus)
        
        sceneView.scene.rootNode.addChildNode(earthParent)
        sceneView.scene.rootNode.addChildNode(venusParent)
        
        earthParent.addChildNode(earth)
        earthParent.addChildNode(moonParent)
        venusParent.addChildNode(venus)
        moonParent.addChildNode(moon)
        earth.addChildNode(moon)
    }
    
    private func configureSunNode() {
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        sun.geometry?.firstMaterial?.diffuse.contents = UIImage.sunDiffuse
        sun.position = SCNVector3(x: .zero, y: .zero, z: -1)
        sceneView.scene.rootNode.addChildNode(sun)
        rotate(planet: sun)
    }
    
    private func rotate(planet: SCNNode, with duration: TimeInterval = 8) {
        let action = SCNAction.rotateBy(x: .zero, y: 360.degreesToRadians, z: .zero, duration: duration)
        let forever = SCNAction.repeatForever(action)
        planet.runAction(forever)
    }
    
    private func planet(
        withRadius radius: CGFloat,
        diffuse: UIImage,
        specular: UIImage?,
        emission: UIImage?,
        normal: UIImage?,
        position: SCNVector3
    ) -> SCNNode {
        let planet = SCNNode(geometry: SCNSphere(radius: radius))
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        
        return planet
    }
}
