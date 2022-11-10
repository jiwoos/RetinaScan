//
//  ViewController.swift
//  demoRetinaScan
//
//  Created by Jiwoo Seo on 11/3/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var objectView: UIImageView!
    @IBOutlet weak var modeController: UISegmentedControl!
    @IBOutlet weak var uiViewBackground: UIView!
    @IBOutlet weak var sceneView: ARSCNView!
    
    var faceNode = SCNNode()
    var leftEye = SCNNode()
    var rightEye = SCNNode()

    //-----------------------
    // MARK: - View LifeCycle
    //-----------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        objectView.image = UIImage(named:"foo")

        // Set up face tracking
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        
        setupEyeNode()
    }

    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
        
    }

    //-----------------------
    // MARK: - Eye Node Setup
    //-----------------------

    // Creates to SCNSpheres to loosely represent the eyes
    func setupEyeNode(){

        // Create a node to represent the eye
        let eyeGeometry = SCNSphere(radius: 0.005)
        eyeGeometry.materials.first?.diffuse.contents = UIColor.cyan
        eyeGeometry.materials.first?.transparency = 1

        // Create a holder node and rotate it
        // so that the geometry points towards the device
        let node = SCNNode()
        node.geometry = eyeGeometry
        node.eulerAngles.x = -.pi / 2
        node.position.z = 0.1

        // Create left and right eye
        leftEye = node.clone()
        rightEye = node.clone()
    }
    

    @IBAction func modeChanged(_ sender: Any) {
        switch modeController.selectedSegmentIndex
            {
            case 0:
                sceneView.isHidden = true
            case 1:
                sceneView.isHidden = false
            default:
                break
            }
    }
    

}

    
