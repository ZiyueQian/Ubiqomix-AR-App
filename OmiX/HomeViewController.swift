//
//  ViewController.swift
//  OmiX
//
//  Copyright © 2019 Wellesley HCI. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import FittedSheets
import Charts
import Vision


class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    var pieView: PieChartInfoBox!
    var allergenView: AllergenInfoBox!
    var allergen2View: Allergen2InfoBox!
    var popup: UIView!
    private var viewModel: ARViewModel!
    
    var sampleNodes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
//        sceneView.session.delegate = self
        sceneView.scene.physicsWorld.gravity = SCNVector3Make(0.0, -1.0, 0.0)
        pieView = PieChartInfoBox.fromNib() as! PieChartInfoBox
        allergenView = AllergenInfoBox.fromNib() as! AllergenInfoBox
        allergen2View = Allergen2InfoBox.fromNib() as! Allergen2InfoBox
        configureLighting()
        addGesturesToSceneView()
//        viewModel = ARViewModel(sceneView: sceneView)
//        viewModel.stateChangeHandler = { [weak self] change in
//            self?.applyStateChange(change)
//        }
        do {
            let map = try loadWorldMap()
            resetTrackingConfiguration(with:map)
        } catch {
            print("load map fail")
        }
    }
    
    func applyStateChange(_ change: ARState.Change) {       //face recognition - not needed
        DispatchQueue.main.async {
            switch change {
            case let .node(node):
                guard let node = node else { return }
                self.sceneView.scene.rootNode.addChildNode(node)
            }
        }
    }

    func updateFilters() {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if let name = node.name {
                if let nodeInfo = StateController.shared.nodes[name] {
                    let selectedFilters = StateController.shared.filters
                    if (!selectedFilters.isEmpty && selectedFilters.isSubset(of: nodeInfo.filters)) {
                        node.isHidden = false
                    } else {
                        node.isHidden = true
                    }
                }
            }
        }
    }
    
    @IBAction func modifyFilters(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        let sheetController = SheetViewController(controller: controller, sizes: [.halfScreen, .fullScreen])
        
        sheetController.didDismiss = { _ in
           self.updateFilters()
        }
        
        self.present(sheetController, animated: false, completion: nil)
        
    }
    
    @IBAction func addsample(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddSampleViewController") as! AddSampleViewController
        let sheetController = SheetViewController(controller: controller, sizes: [.halfScreen, .fullScreen])
        self.present(sheetController, animated: false, completion: nil)
    }
    
    @IBAction func showHelp(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
        let sheetController = SheetViewController(controller: controller, sizes: [.halfScreen, .fullScreen])
        self.present(sheetController, animated: false, completion: nil)
    }

    func configureLighting() {  //AR view
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {    //AR view
        super.viewWillAppear(animated)
        resetTrackingConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {     //AR view
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func resetTrackingConfiguration(with worldMap: ARWorldMap? = nil) {    //AR view
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
    }
    
    var worldMapUrl: URL = {    //AR view
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("OmixWorldMapURL")
        } catch {
            fatalError("Error getting world map URL from document directory.")
        }
    }()
    
    func loadWorldMap() throws -> ARWorldMap {    //AR view
        let mapData = try Data(contentsOf: self.worldMapUrl)
        guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: mapData)
            else { throw ARError(.invalidWorldMap) }
        print("map loaded")
        return worldMap
    }
    
    func saveWorldMap(){    //AR view
        sceneView.session.getCurrentWorldMap { (worldMap, error) in
            guard let worldMap = worldMap else {
                return
            }
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
                try data.write(to: self.worldMapUrl)
                print("world map saved")
            } catch {
                print("error")
            }
    
        }
    }
    
    //showing the alert message for user to scan the room
    func showAlert() {
        popup = UINib(nibName: "AlertMessage", bundle: .main).instantiate(withOwner: nil, options: nil).first as? UIView
        popup.backgroundColor = UIColor.clear
        popup.center = CGPoint(x: self.view.bounds.midX,
                               y: self.view.bounds.midY);
        // show on screen
        self.view.addSubview(popup)
        
        // set the timer
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    
    @objc func dismissAlert(){
        if popup != nil { // Dismiss the view from here
            popup.removeFromSuperview()
        }
    }
    
    //long press gesture will allow user to delete the info boxes
    func addGesturesToSceneView() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didReceiveLongPressGesture(_:)))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didReceiveTapGesture(_:)))
        
        longPressGestureRecognizer.minimumPressDuration = 0.25
        longPressGestureRecognizer.require(toFail: tapGestureRecognizer)

        sceneView.addGestureRecognizer(tapGestureRecognizer)
        sceneView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func didReceiveLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: sceneView)
        guard let hitTestResults = sceneView.hitTest(location, options: nil).first
            else { return }
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Delete Sample", message: "Are you sure you want to delete this sample?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            let node = hitTestResults.node
            node.removeFromParentNode()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    //anchor - adds info boxes to the real world
    @objc func didReceiveTapGesture(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        guard let hitTestResults = sceneView.hitTest(location, options: nil).first
            else {
                
                if (StateController.shared.selectedSample.location != "") {
                    let location = sender.location(in: sceneView)
                    guard let hitTestResult = sceneView.hitTest(location, types: [.featurePoint, .estimatedHorizontalPlane, .estimatedVerticalPlane]).first
                        else {
                            self.showAlert()
                            return
                    }
                    let anchor = ARAnchor(transform: hitTestResult.worldTransform)
                    sceneView.session.add(anchor: anchor)
                }
                return
        }
        
        if let nodeID = hitTestResults.node.name {
            StateController.shared.tappedNode = nodeID
        }
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let sheetController = SheetViewController(controller: controller, sizes: [.fullScreen])
        self.present(sheetController, animated: false, completion: nil)
        //print(nodeID)
    }
    
    func customNode(sample: Datum) -> SCNNode {
        guard let thePie = pieView else { return SCNNode()}
        guard let theAllergen = allergenView else { return SCNNode()}
        guard let theAllergen2 = allergen2View else { return SCNNode()}
        let plane = SCNPlane(width: 282/1000, height: 169/1000)
        plane.cornerRadius = 0.01
        
        let imageMaterial = SCNMaterial()
        
        switch StateController.shared.selectedSample.type {
        case "detection":
            if (StateController.shared.selectedSample.level == "high") {
                if (StateController.shared.selectedSample.risk2 == nil) {
                    self.allergenView.set(name: (StateController.shared.selectedSample.name), imageName: (StateController.shared.selectedSample.risk!), details: ("contains: " + StateController.shared.selectedSample.risk!))
                    allergenView.layer.borderWidth = 1
                    allergenView.layer.borderColor = UIColor.red.cgColor
                    imageMaterial.diffuse.contents = theAllergen.asImage()
                } else {        //for 2 allergy icons
                    self.allergen2View.set(name: (StateController.shared.selectedSample.name), imageName: (StateController.shared.selectedSample.risk!), image2Name: (StateController.shared.selectedSample.risk2!), details: ("contains: " + StateController.shared.selectedSample.risk! + " and " + StateController.shared.selectedSample.risk2!))
                    allergen2View.layer.borderWidth = 1
                    allergen2View.layer.borderColor = UIColor.black.cgColor
                    imageMaterial.diffuse.contents = theAllergen2.asImage()
                }
                
            } else {
                if (StateController.shared.selectedSample.risk2 == nil) {
                    self.allergenView.set(name: (StateController.shared.selectedSample.name), imageName: ("no " +  StateController.shared.selectedSample.risk!), details: ("no " + StateController.shared.selectedSample.risk!))
                    allergenView.layer.borderWidth = 1
                    allergen2View.layer.borderColor = UIColor.black.cgColor
                    imageMaterial.diffuse.contents = theAllergen.asImage()
                } else {        //contains 2 allergy icons
                    self.allergen2View.set(name: (StateController.shared.selectedSample.name), imageName: ("no " +  StateController.shared.selectedSample.risk!), image2Name: ("no " + StateController.shared.selectedSample.risk2!), details: ("no " + StateController.shared.selectedSample.risk! + " or " + StateController.shared.selectedSample.risk2!))
                    allergen2View.layer.borderWidth = 1
                    allergen2View.layer.borderColor = UIColor.black.cgColor
                    imageMaterial.diffuse.contents = theAllergen2.asImage()
                }
                
            }
            
            
        case "identification":
            if let count = StateController.shared.selectedSample.identities?.count {
                if count > 1 {
                    var labelsArray = [String]()
                    var valuesArray = [Double]()
                    for num in 0..<count {
                        if let perc = StateController.shared.selectedSample.identities?[num].percentage {
                            valuesArray.append(Double(perc) ?? 0.0)
                            labelsArray.append(StateController.shared.selectedSample.identities?[num].name ?? "")
                        }
                    }
                    self.pieView.setData((StateController.shared.selectedSample.name), subtype: StateController.shared.selectedSample.subtype!, labels: labelsArray, values: valuesArray)
                    pieView.layer.borderWidth = 1
                    pieView.layer.borderColor = UIColor.black.cgColor
                    imageMaterial.diffuse.contents = thePie.asImage()
                } else {
                    let perc = (StateController.shared.selectedSample.identities?[0].percentage) ?? "Unknown"
                    let sciName = (StateController.shared.selectedSample.identities?[0].name) ?? "Unknown"
                    let image = (StateController.shared.selectedSample.image) ?? "question"
                    self.allergenView.set(name: (StateController.shared.selectedSample.name), imageName: image, details: (perc + "% " + sciName))
                    
                    allergenView.layer.borderWidth = 1
                    allergenView.layer.borderColor = UIColor.black.cgColor
                    imageMaterial.diffuse.contents = theAllergen.asImage()
                }
            }
            
        case "composition":
            if let count = StateController.shared.selectedSample.identities?.count {
                var labelsArray = [String]()
                var valuesArray = [Double]()
                var colorsArray = [UIColor]()
                for num in 0..<count {
                    if let perc = StateController.shared.selectedSample.identities?[num].percentage {
                        valuesArray.append(Double(perc) ?? 0.0)
                        labelsArray.append(StateController.shared.selectedSample.identities?[num].name ?? "")
                    }
                    //setting the color of each individual slice
                    if StateController.shared.selectedSample.identities?[num].danger == "high" {
                        colorsArray.append(UIColor(red: 255/255, green: 69/255, blue: 66/255, alpha: 1.0))     //red
                    } else {
                        colorsArray.append(UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1.0))    //grey
                    }
                    
                }
                self.pieView.setData((StateController.shared.selectedSample.name), subtype: "bacteria", labels: labelsArray, values: valuesArray, colorsArray: colorsArray)
                pieView.layer.borderWidth = 1
                pieView.layer.borderColor = UIColor.black.cgColor
                imageMaterial.diffuse.contents = thePie.asImage()
            }
        default:
            print("No type")
        }
        
        plane.materials = [imageMaterial]
        let info = SCNNode(geometry: plane)
        info.constraints = [SCNBillboardConstraint()]
        info.localTranslate(by: SCNVector3Make(0, 0.15, 0))
        return info
    }
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard !(anchor is ARPlaneAnchor) else { return }
        let sampleNode = customNode(sample: StateController.shared.selectedSample)

        let imageMaterial = SCNMaterial()
        imageMaterial.isDoubleSided = false
        imageMaterial.diffuse.contents = UIImage(named: "indicator")        //green dot to show the data sample
        let plane = SCNPlane(width: 0.025, height: 0.025)
        let indicator = SCNNode(geometry: plane)
        indicator.geometry?.materials = [imageMaterial]
        indicator.opacity = 0.5
        indicator.constraints = [SCNBillboardConstraint()]

        DispatchQueue.main.async {      //how to add the node
            node.addChildNode(indicator)
            node.addChildNode(sampleNode)
            
            let nodeIdentifier = anchor.identifier.uuidString
            sampleNode.name = nodeIdentifier
            indicator.name = nodeIdentifier
            sampleNode.isHidden = true
            
            StateController.shared.nodes[nodeIdentifier] = StateController.shared.selectedSample

            self.sampleNodes.append(nodeIdentifier)

            StateController.shared.selectedSample = Datum(location: "", name: "", date: "", type: "", amount: nil, level: nil, risk: nil, filters: [], details: [], tip: nil, risk2: nil, image: nil, identities: nil, subtype: nil, tipImage: nil, bacteriaCounts: [])
            
            
            self.saveWorldMap()
        }
    }
}
//
//extension ViewController: ARSessionDelegate {
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        viewModel.takeCapturedImage(from: frame)
//    }
//}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
