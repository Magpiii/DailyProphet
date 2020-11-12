//
//  ViewController.swift
//  DailyProphet
//
//  Created by Hunter Hudson on 11/12/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //Specify reference image: 
        if  let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) {
            //Set images to detect:
            configuration.detectionImages = imagesToTrack
            
            //Set the max amount of images that can be tracked:
            configuration.maximumNumberOfTrackedImages = 1
            
            print("Images successfully added to application.")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        //Check to see if the anchor detected is in fact an image:
        if let imageAnchor = anchor as? ARImageAnchor {
            //Print the detected image name to the console:
            print(imageAnchor.referenceImage.name!)
            
            /*Init new videoNode constant which finds the file based on its name in the app bundle:
            */
            let videoNode = SKVideoNode(fileNamed: "DailyProphet.mp4")
            
            //Play the video when the image is recognized:
            videoNode.play()
            
            /*Init new videoScene of type SKScene with appropriate proportions for a 720p video:
            */
            let videoScene = SKScene(size: CGSize(width: 720, height: 1280))
            
            //Position the videoNode in the middle of the detected image:
            videoNode.position = CGPoint(x: (videoScene.size.width / 2), y: (videoScene.size.height / 2))
            
            //Flip video across the y-axis so it doesn't play upside down:
            videoNode.yScale = -1.0
            
            //Add videoNode to videoScene:
            videoScene.addChild(videoNode)
            
            /*Init new plane using the width and height of the reference image of the imageAnchor:
            */
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            /*Assign material of the plane as the video, which will make the video play over the plane:
            */
            plane.firstMaterial?.diffuse.contents = videoScene
            
            //Init new node on plane with the geometry of the plane created above:
            let planeNode = SCNNode(geometry: plane)
            
            //Rotates the plane by pi / 2 so it's flat on the picture:
            planeNode.eulerAngles.x = -(.pi / 2)
            
            //Add planeNode:
            node.addChildNode(planeNode)
    }
        return node
}
    
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
