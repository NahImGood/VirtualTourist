//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Eli Warner on 4/7/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Variables
    var fetchedResultController:NSFetchedResultsController<Pin>!
    var annotations: [MKAnnotation] = [MKAnnotation]()
    var pins: [Pin] = [Pin]()
    var selectedPin: Pin?
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMapview()
        mapView.delegate = self
        pins = fetchPins()
        populateMap()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
}

//MARK:Pin Drop function
extension MapViewController {
    
    func setMapview(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == UIGestureRecognizer.State.ended {
            let touchPoint: CGPoint = gestureReconizer.location(in: mapView)
            let touchCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            mapView.addAnnotation(createPin(touchCoordinate))
            performSegue(withIdentifier: "detail", sender: self)
        }
        if gestureReconizer.state == UIGestureRecognizer.State.began {
            return
        }
    }

}

//MARK: Saving of pin
extension MapViewController {
    
    func createPin(_ location: CLLocationCoordinate2D) -> Pin {
        let pin: Pin = Pin(latitude: location.latitude, longitude: location.longitude, dataController.viewContext)
        try? dataController.viewContext.save()
        selectedPin = pin
        print(selectedPin!)
        return pin
    }
    
    func fetchPins() -> [Pin] {
        var pins = [Pin]()
        let fetchResult: NSFetchRequest<NSFetchRequestResult> = Pin.fetchRequest()
        
        do {
            let results = try dataController.viewContext.fetch(fetchResult) as! [Pin]
            pins = results
        } catch let e as NSError {
            print("Error while trying to perform a search: \n\(e)")
        }
        return pins
    }
    
    func populateMap() {
        for pin in pins {
            mapView.addAnnotation(pin)
        }
    }
    
    /* TODO: Add location Tracking
    func lastLocation(){
        var noLocation = CLLocationCoordinate2D()
        if isKeyPresentInUserDefaults(key: "lat") {
            if isKeyPresentInUserDefaults(key: "long") {
                noLocation.latitude = UserDefaults.standard.double(forKey: "lat")
                } else {
                    noLocation.longitude = 0.0
                }
                noLocation.longitude = UserDefaults.standard.double(forKey: "long")
            } else {
            noLocation.latitude = 0.0
        }
        let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: false)
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
 */
}

// MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.animatesDrop = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
        selectedPin = view.annotation as? Pin
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detail") {
            let collectionVC = segue.destination as! PhotoCollectionViewController
            collectionVC.selectedPin = self.selectedPin
            collectionVC.dataController = self.dataController
        }
    }
    
}
