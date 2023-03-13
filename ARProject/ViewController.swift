//
//  ViewController.swift
//  ARProject
//
//  Created by Apps2M on 13/3/23.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    var bottomText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let faceMesh = ARSCNFaceGeometry(device: sceneView.device!)
        
        let node = SCNNode(geometry: faceMesh)
        
        node.geometry?.firstMaterial?.fillMode = .lines
        // make it lines
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
            // everytime the mesh detects an update
            
            readMyFace(anchor: faceAnchor)
            // run readMyFace function
            
            DispatchQueue.main.async { self.bottomLabel.text = self.bottomText }
            // Update the text on the main thread
        }
    }
    
    func readMyFace(anchor: ARFaceAnchor) {
        // function that takes an ARFaceAnchor in as a parameter
        
        let mouthSmileLeft = anchor.blendShapes[.mouthSmileLeft]
        let mouthSmileRight = anchor.blendShapes[.mouthSmileRight]
        let cheekPuff = anchor.blendShapes[.cheekPuff]
        let tongueOut = anchor.blendShapes[.tongueOut]
        let jawLeft = anchor.blendShapes[.jawLeft]
        let eyeSquintLeft = anchor.blendShapes[.eyeSquintLeft]
        // Define different anchors utilizing classes in the imported kit
        
        self.bottomText = "You are still faced"
        // when this function is running I want to signal to the user that the function is reacting
        
        if ((mouthSmileLeft?.decimalValue ?? 0.0) + (mouthSmileRight?.decimalValue ?? 0.0)) > 0.9 { self.bottomText = "You are smiling "  }
        // smiling
        if cheekPuff?.decimalValue ?? 0.0 > 0.4 { self.bottomText = "You are puffing your cheeks " }
        // puffy cheeks
        if tongueOut?.decimalValue ?? 0.0 > 0.1 {self.bottomText = "You are sticking your tongue out"}
        // tongue out
        if jawLeft?.decimalValue ?? 0.0 > 0.1 {self.bottomText = "You are moving your jaw to the left"}
        // left jaw
        if eyeSquintLeft?.decimalValue ?? 0.0 > 0.2 {self.bottomText = "You are squinting your left eye"}
        // left eye squint
        // different if statements to update the bottomText based off the facial expression
    }
    
}

