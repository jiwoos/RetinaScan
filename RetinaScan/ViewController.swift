//
//  ViewController.swift
//  RetinaScan
//
//  Created by Jiwoo Seo on 11/3/22.
//

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    // Outlets that connect with Storyboard objects
    @IBOutlet weak var objectView: UIImageView!
    @IBOutlet weak var modeController: UISegmentedControl!
    @IBOutlet weak var uiViewBackground: UIView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var distanceLabel: UILabel! //displays the distance in cm
    
    // SCNNode objects for face detection
    var faceNode = SCNNode()
    var leftEye = SCNNode()
    var rightEye = SCNNode()

    
    var width: CGFloat!
    var height: CGFloat!

    var averageDistanceCM = 30.0
    var isPinching = false
    var setUpDefault = false
    var initDistance = 50.0

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
        setupSize()
        addGesture()
    }

    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
        
    }

    
    
    
    
    
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
    
    func setupSize() {
        width = objectView.frame.width
        height = objectView.frame.height
    }
    
    
    
    
    
    
    // Functionality to zoom/pinch the object (snellen eye chart)
    private func addGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        objectView.isUserInteractionEnabled = true
        objectView.addGestureRecognizer(pinchGesture)
    }
    
    @objc private func didPinch(_ gesture:UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            let scale = gesture.scale
            objectView.frame = CGRect(x: 0, y: 0, width: width * scale, height: height * scale)
            objectView.center = view.center
            isPinching = true
            setUpDefault = false
        }
        else if gesture.state == .ended {
            setupSize()
            isPinching = false
            print("pinch ended")
        }
    }

    
    
    
    
    // Toggle button to switch between Basic/Developer mode
    @IBAction func modeChanged(_ sender: Any) {
        switch modeController.selectedSegmentIndex
            {
            case 0:
                sceneView.isHidden = true
                distanceLabel.isHidden = true
            case 1:
                sceneView.isHidden = false
                distanceLabel.isHidden = false
            default:
                break
            }
    }
    
    
    
    
    
    // Button to open image from the Photos Gallery
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
            setupSize()
            picker.dismiss(animated:true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
    

}

    
