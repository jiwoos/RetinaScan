//
//  ARSCNViewDelegate.swift
//  RetinaScan
//
//  Created by Jiwoo Seo on 11/3/22.
//

import Foundation
import CoreGraphics
import SceneKit
import ARKit

// ViewController that takes responsibility in detecting face and tracking the distance between the device and the user's eyes
extension ViewController: ARSCNViewDelegate{

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        // Setting up the face and eye nodes
        faceNode = node
        faceNode.addChildNode(leftEye)
        faceNode.addChildNode(rightEye)
        faceNode.transform = node.transform

        // get the distance and set the object size accordingly
        trackDistance()
        setObjectSize()
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        faceNode.transform = node.transform

        // Check if we have a valid ARFaceAnchor
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        if faceAnchor.isTracked {
            addObject()
        } else {
            deleteObject()
        }
        
        // Update the Transform of the left and right eyes from the Anchor Transform
        leftEye.simdTransform = faceAnchor.leftEyeTransform
        rightEye.simdTransform = faceAnchor.rightEyeTransform

        if (!isPinching) {
            trackDistance()
            setObjectSize()
        }
    }
    
    
    
    // adds the object when face is detected 
    func addObject() {
        DispatchQueue.main.async {
            self.objectView.isHidden = false
            self.uiViewBackground.center = super.view.center
            self.uiViewBackground.backgroundColor = UIColor.lightGray
        }
    }
    
    
    
    // deletes the object when face is not detected
    func deleteObject() {
        DispatchQueue.main.async {
            self.uiViewBackground.backgroundColor = UIColor.red
            self.objectView.isHidden = true
        }
       
    }
    
    
    
    
    // Tracks the distance of the eyes from the camera
    func trackDistance(){

        DispatchQueue.main.async { [self] in
            // Get the distance the eyes from the camera
            let leftEyeDistanceFromCamera = self.leftEye.worldPosition - SCNVector3Zero
            let rightEyeDistanceFromCamera = self.rightEye.worldPosition - SCNVector3Zero

            // Calculate the average distance of the eyes to the camera
            let averageDistance = (leftEyeDistanceFromCamera.length() + rightEyeDistanceFromCamera.length()) / 2
            self.self.averageDistanceCM = Double((round(averageDistance * 1000)))
            print("Approximate distance from the camera = \(averageDistanceCM/10)")
            let distanceInStr = String(averageDistanceCM/10) + "mm"
            self.distanceLabel.text = "Approx Distance: " + distanceInStr
            
            if (!self.setUpDefault) {
                self.initDistance = averageDistanceCM
                self.setUpDefault = true
            }
        }
    }
    
    
    
    
    
    // Calculate the size of the object
    func setObjectSize() {
        DispatchQueue.main.async {
            let newWidth = (self.width)*CGFloat(self.averageDistanceCM/self.initDistance)
            let newHeight = (self.height)*CGFloat(self.averageDistanceCM/self.initDistance)
            self.objectView.frame = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
            self.objectView.center = self.view.center

        }
    }
    
}
