//
//  ViewController.swift
//  Concrete
//
//  Created by Ziya Rustamov on 11.10.23.
//

import UIKit
import ARKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    private let configuration = ARWorldTrackingConfiguration()
    private let motionManager = CMMotionManager()
    private var vehicle = SCNPhysicsVehicle()
    private var orientation: CGFloat = .zero
    private var touched: Int = .zero
    private var accelerationValues: (x: Double, y: Double) = (x: .zero, y: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSceneView()
        setUpAccelerometer()
    }

    private func configureSceneView() {
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    private func createConcrete(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let concreteNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.planeExtent.width), height: CGFloat(planeAnchor.planeExtent.height)))
        concreteNode.geometry?.firstMaterial?.diffuse.contents = UIImage.concrete
        concreteNode.geometry?.firstMaterial?.isDoubleSided = true
        concreteNode.position = SCNVector3(x: planeAnchor.center.x, y: planeAnchor.center.y, z: planeAnchor.center.z)
        concreteNode.eulerAngles = SCNVector3(x: 90.degreesToRadians, y: .zero, z: .zero)
        let staticBody = SCNPhysicsBody.static()
        concreteNode.physicsBody = staticBody
        return concreteNode
    }
    
    private func configureCamera() {
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let orientation = SCNVector3(x: -transform.m31, y: -transform.m32, z: -transform.m33)
        let location = SCNVector3(x: transform.m41, y: transform.m42, z: transform.m43)
        let currentPositionOfCamera = orientation + location
        setUpVehicle(with: currentPositionOfCamera)
    }
    
    private func setUpVehicle(with currentPositionOfCamera: SCNVector3) {
        guard let scene = SCNScene.getScene(),
              let chassis = scene.rootNode.childNode(withName: String.chassis, recursively: false),
              let frontLeftWheelNode = chassis.childNode(withName: String.frontLeftWheel, recursively: false),
              let frontRightWheelNode = chassis.childNode(withName: String.frontRightWheel, recursively: false),
              let rearLeftWheelNode = chassis.childNode(withName: String.rearLeftWheel, recursively: false),
              let rearRightWheelNode = chassis.childNode(withName: String.rearRightWheel, recursively: false) else { return }
        
        let frontLeftWheel = SCNPhysicsVehicleWheel(node: frontLeftWheelNode)
        let frontRightWheel = SCNPhysicsVehicleWheel(node: frontRightWheelNode)
        let rearRightWheel = SCNPhysicsVehicleWheel(node: rearRightWheelNode)
        let rearLeftWheel = SCNPhysicsVehicleWheel(node: rearLeftWheelNode)
        
        chassis.position = currentPositionOfCamera
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: chassis, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        body.mass = 1
        chassis.physicsBody = body
        
        guard let physicsBody = chassis.physicsBody else { return }
        vehicle = SCNPhysicsVehicle(chassisBody: physicsBody, wheels: [rearRightWheel, rearLeftWheel, frontRightWheel, frontLeftWheel])
        sceneView.scene.physicsWorld.addBehavior(vehicle)
        sceneView.scene.rootNode.addChildNode(chassis)
    }
    
    private func setUpAccelerometer() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1 / 60
            motionManager.startAccelerometerUpdates(to: .main) { accelerometerData, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let accelerometerData = accelerometerData else { return }
                self.accelerometerDidChange(acceleration: accelerometerData.acceleration)
            }
        } else {
            print("Accelerometer not available")
        }
    }
    
    private func accelerometerDidChange(acceleration: CMAcceleration) {
        accelerationValues.y = filtered(previousAcceleration: accelerationValues.y, UpdatedAcceleration: acceleration.y)
        accelerationValues.x = filtered(previousAcceleration: accelerationValues.x, UpdatedAcceleration: acceleration.x)
        if accelerationValues.x > .zero {
            orientation = -CGFloat(accelerationValues.y)
        } else {
            orientation = CGFloat(accelerationValues.y)
        }
    }
    
    private func filtered(previousAcceleration: Double, UpdatedAcceleration: Double) -> Double {
        let kfilteringFactor = 0.5
        return UpdatedAcceleration * kfilteringFactor + previousAcceleration * (1-kfilteringFactor)
    }
    
    @IBAction func addCar(_ sender: Any) {
        configureCamera()
    }
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else { return }
        touched += touches.count
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = .zero
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let concreteNode = createConcrete(planeAnchor: planeAnchor)
        node.addChildNode(concreteNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        node.enumerateChildNodes { childNode, _ in
            childNode.removeFromParentNode()
        }
        
        let concreteNode = createConcrete(planeAnchor: planeAnchor)
        node.addChildNode(concreteNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARPlaneAnchor else { return }
        
        node.enumerateChildNodes { childNode, _ in
            childNode.removeFromParentNode()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        var engineForce: CGFloat = .zero
        var brakingForce: CGFloat = .zero
        vehicle.setSteeringAngle(-orientation, forWheelAt: 2)
        vehicle.setSteeringAngle(-orientation, forWheelAt: 3)
        if touched == 1 {
            engineForce = 5
        } else if touched == 2 {
            engineForce = -5
        } else if touched == 3 {
            brakingForce = 100
        } else {
            engineForce = .zero
        }
        
        vehicle.applyEngineForce(engineForce, forWheelAt: 0)
        vehicle.applyEngineForce(engineForce, forWheelAt: 1)
        vehicle.applyBrakingForce(brakingForce, forWheelAt: 0)
        vehicle.applyBrakingForce(brakingForce, forWheelAt: 1)
    }
}

private extension String {
    static let chassis = "chassis"
    static let frontLeftWheel = "frontLeftParent"
    static let frontRightWheel = "frontRightParent"
    static let rearLeftWheel = "rearLeftParent"
    static let rearRightWheel = "rearRightParent"
}
