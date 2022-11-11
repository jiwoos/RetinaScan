//
//  ViewController.swift
//  demoRetinaScan
//
//  Created by Jiwoo Seo on 11/3/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var objectView: UIImageView!
    @IBOutlet weak var modeController: UISegmentedControl!
    @IBOutlet weak var uiViewBackground: UIView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var distanceLabel: UILabel! //displays the distance in cm
    @IBOutlet weak var approxDistText: UILabel! // just label
    
    var faceNode = SCNNode()
    var leftEye = SCNNode()
    var rightEye = SCNNode()
    var averageDistanceCM = 30.0

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
                distanceLabel.isHidden = true
                approxDistText.isHidden = true
            case 1:
                sceneView.isHidden = false
                distanceLabel.isHidden = false
                approxDistText.isHidden = false
            default:
                break
            }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        let imgPickerCtrl = UIImagePickerController()
        imgPickerCtrl.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "camera", style: .default, handler: { (actions: UIAlertAction) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        imgPickerCtrl.sourceType = .camera
                        self.present(imgPickerCtrl, animated: true, completion: nil)
                }
                else {
                    print("Camera is not available!")
                }
            }))
                actionSheet.addAction(UIAlertAction(title: "photo library", style: .default, handler: { (actions: UIAlertAction) in imgPickerCtrl.sourceType = .photoLibrary
                    self.present(imgPickerCtrl, animated: true, completion: nil)
                }))
                actionSheet.addAction(UIAlertAction(title: "never mind", style: .cancel, handler: nil))
                self.present(actionSheet, animated:true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            objectView.image = image
            picker.dismiss(animated:true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    

}

    
