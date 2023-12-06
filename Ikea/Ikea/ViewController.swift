//
//  ViewController.swift
//  Ikea
//
//  Created by Ziya Rustamov on 13.10.23.
//

import UIKit
import ARKit

final class ViewController: UIViewController {

    private var selectedItem: Item?
    @IBOutlet weak var planeDetected: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    private let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerGestureRecognizers()
        configureCollectionView()
        configureScene()
    }
    
    private func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(rotate))
        longPressGestureRecognizer.minimumPressDuration = 0.1
        sceneView.addGestureRecognizer(longPressGestureRecognizer)
        sceneView.addGestureRecognizer(pinchGestureRecognizer)
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    private func configureCollectionView() {
        itemsCollectionView.dataSource = self
        itemsCollectionView.delegate = self
    }

    private func configureScene() {
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        sceneView.delegate = self
        configuration.planeDetection = .horizontal
        sceneView.autoenablesDefaultLighting = true
        sceneView.session.run(configuration)
    }
    
    private func addItem(arRaycastResult: ARRaycastResult) {
        guard let selectedItem = selectedItem else { return }
        
        let scene = SCNScene.getScene(using: selectedItem)
        
        guard let node = scene.rootNode.childNode(withName: selectedItem.rawValue, recursively: false) else { return }
        
        let transform = arRaycastResult.worldTransform
        let thirdColumn = transform.columns.3 // Transform matrix encodes position of the surface. The position of the horizontal surface is encoded in third column in our case
        node.position = SCNVector3(x: thirdColumn.x, y: thirdColumn.y, z: thirdColumn.z) // Positioning our node where detected surface is
        if selectedItem == .table {
            self.centerPivot(for: node)
        }
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    private func centerPivot(for node: SCNNode) {
        let min = node.boundingBox.min
        let max = node.boundingBox.max
        node.pivot = SCNMatrix4MakeTranslation(
            min.x + (max.x - min.x) / 2,
            min.y + (max.y - min.y) / 2,
            min.z + (max.z - min.z) / 2
        )
    }
    
    @objc private func pinch(sender: UIPinchGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        let pinchLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(pinchLocation)
        
        guard let results = hitTest.first else { return }
        let node = results.node
        let pinchAction = SCNAction.scale(by: sender.scale, duration: .zero)
        node.runAction(pinchAction)
        sender.scale = 1.0
    }
    
    @objc private func tapped(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        let tapLocation = sender.location(in: sceneView)
        guard let hitTest = sceneView.raycastQuery(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal) else { return }
        let results: [ARRaycastResult] = self.sceneView.session.raycast(hitTest)
        guard let firstResult = results.first else { return }
        addItem(arRaycastResult: firstResult)
    }
    
    @objc private func rotate(sender: UILongPressGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        let holdLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(holdLocation)
        
        guard let result = hitTest.first else { return }
        
        if sender.state == .began {
            let rotation = SCNAction.rotateBy(x: .zero, y: 360.degreesToRadians, z: .zero, duration: 1)
            let forever = SCNAction.repeatForever(rotation)
            result.node.runAction(forever)
        } else if sender.state == .ended {
            result.node.removeAllActions()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Item.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.cellReuseIdentifier, for: indexPath) as? ItemCell else { return UICollectionViewCell() }
        cell.itemLabel.text = Item.allCases[indexPath.item].rawValue
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        selectedItem = Item.allCases[indexPath.item]
        cell?.backgroundColor = .green
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .orange
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        DispatchQueue.main.async {
            self.planeDetected.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.planeDetected.isHidden = true
            }
        }
    }
}

private extension String {
    static let modelsFolderName = "Models.scnassets"
    static let cup = "cup"
    static let vase = "vase"
    static let boxing = "boxing"
    static let table = "table"
    static let cellReuseIdentifier = "item"
}
