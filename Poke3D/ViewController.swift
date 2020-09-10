//
//  ViewController.swift
//  Poke3D
//
//  Created by Jamie Kim  on 9/7/20.
//  Copyright © 2020 Jamie Kim . All rights reserved.
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
        
        //fix model being look weird
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration to recognize images as well as planes
        let configuration = ARImageTrackingConfiguration()
        
        //let it know where to find images to track
        if let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "poketmon cards", bundle: Bundle.main){
            
            configuration.trackingImages = imagesToTrack
            //1->2 simultaneously track images
            configuration.maximumNumberOfTrackedImages = 2
            //print when it manged to find poketmon cards in working directory and turn them into reference images.
            print("Images Successfully Added")
            
        }
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - renderer triggered whenever image anchor detected
    //anchor: things being detected
    //node: 3D objects in respond to detect the anchor
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        
        //MARK: - white panel
        //type check if that image anchor is ARImageAnchor
        if let imageAnchor = anchor as? ARImageAnchor{
            
            //print(imageAnchor.referenceImage.name)
            
            //same size as plane card
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)

            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.9)
            
            //now create a plane node: 3D objects
            let planeNode = SCNNode(geometry: plane)

            //need to rotate it anti-clockwise 90 degree so that it completely attached
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)


            //MARK: - add detected scenes to plane
            //when anchorImages detected, add the scenes to the planeNode
            //if eevee card, then render eevee scene and add node to plane node
            if imageAnchor.referenceImage.name == "eevee"{
                //want to place it on the top on the planeNode
                if let pokeScene1 = SCNScene(named: "art.scnassets/eevee.scn"){
                    //create a node
                    if let pokeNode1 = pokeScene1.rootNode.childNodes.first{
                        //model falling out needs to be rotated toward clock wise
                        pokeNode1.eulerAngles.x = .pi / 2
                        planeNode.addChildNode(pokeNode1)

                    }
                    
                }
            }
            if imageAnchor.referenceImage.name == "oddish"{
                if let pokeScene2 = SCNScene(named: "art.scnassets/oddish.scn"){
                    //create a node
                    if let pokeNode2 = pokeScene2.rootNode.childNodes.first{
                        
                        pokeNode2.eulerAngles.x = .pi / 2
                        planeNode.addChildNode(pokeNode2)
                    }
                }
                
            }
            
        }
        return node
    }

}
