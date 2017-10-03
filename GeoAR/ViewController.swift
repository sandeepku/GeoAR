//
//  ViewController.swift
//  GeoAR
//
//  Created by Sandeep Kuniel on 02/10/2017.
//  Copyright © 2017 Sandeep Kuniel. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ArcGIS

class ViewController: UIViewController, ARSCNViewDelegate {

    var automaticallyFindTrueNorth = true
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var controlsContainerView: UIView!
   
    @IBOutlet weak var mapView: AGSMapView!
    
    @IBOutlet weak var cameraStateInfoLabel: UILabel!
    
    private var map:AGSMap!
    private let theURLString = "https://portal002.powel.net/arcgis/home/item.html?id=6bcb2b2fdbe64b47b94432643794870d"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleControlViewContainer()
        configureMapView()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    private func configureMapView(){
        map = AGSMap(url: URL(string: theURLString)!)
        self.mapView.map = self.map
    }
    
    // MARK: - Utility methods
    
    private func startSession() {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if automaticallyFindTrueNorth {
            configuration.worldAlignment = .gravityAndHeading
        } else {
            configuration.worldAlignment = .gravity
        }
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    private func styleControlViewContainer() {
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = controlsContainerView.bounds
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        controlsContainerView.insertSubview(blurView, belowSubview: mapView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //sandeep let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        //sandeep sceneView.session.run(configuration)
        startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    /*
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }*/
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print("camera did change tracking state: \(camera.trackingState)")
        
        switch camera.trackingState {
        case .normal:
            cameraStateInfoLabel.text = "Ready!"
            UIView.animate(withDuration: 1, delay: 1, options: [], animations: {
                self.cameraStateInfoLabel.alpha = 0
            }, completion: nil)
        default:
            cameraStateInfoLabel.alpha = 1
            cameraStateInfoLabel.text = "Move the camera"
        }
    }
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
