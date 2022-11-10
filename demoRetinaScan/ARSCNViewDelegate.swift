//
//  ARSCNViewDelegate.swift
//  demoRetinaScan
//
//  Created by Jiwoo Seo on 11/3/22.
//

import Foundation
import CoreGraphics
import SceneKit
import ARKit

//--------------------------
// MARK: - ARSCNViewDelegate
//--------------------------

extension ViewController: ARSCNViewDelegate{

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        // Setting up the face and eyes
        faceNode = node
        faceNode.addChildNode(leftEye)
        faceNode.addChildNode(rightEye)
        faceNode.transform = node.transform

        
        trackDistance()
//        setObjectSize()
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
        // Update the Transform of the left and right eyes
        leftEye.simdTransform = faceAnchor.leftEyeTransform
        rightEye.simdTransform = faceAnchor.rightEyeTransform

        
        trackDistance()
//        setObjectSize()
    }

    func addObject() {
        DispatchQueue.main.async {
            self.objectView.isHidden = false
            self.uiViewBackground.backgroundColor = UIColor.lightGray
        }
    }
    
    func deleteObject() {
        DispatchQueue.main.async {
            self.uiViewBackground.backgroundColor = UIColor.red
            self.objectView.isHidden = true
        }
       
    }
    // Tracks the distance of the eyes from the camera
    func trackDistance(){

        DispatchQueue.main.async {

            // Get the distance the eyes from the camera
            let leftEyeDistanceFromCamera = self.leftEye.worldPosition - SCNVector3Zero
            let rightEyeDistanceFromCamera = self.rightEye.worldPosition - SCNVector3Zero

            // Calculate the average distance
            let averageDistance = (leftEyeDistanceFromCamera.length() + rightEyeDistanceFromCamera.length()) / 2
            let averageDistanceCM = (Int(round(averageDistance * 100)))
            print("Approximate distance from the camera = \(averageDistanceCM)")
            let distanceInStr = String(averageDistanceCM) + "cm"
            self.distanceLabel.text = distanceInStr
        }
    }
    
    func setObjectSize() {
        DispatchQueue.main.async {
            let newWidth = self.objectView.frame.width + 1
            let newHeight = self.objectView.frame.height + 1
            
            self.objectView.frame = CGRectMake (self.objectView.frame.origin.x, self.objectView.frame.origin.y, newWidth, newHeight)
        }
    }
    
}
