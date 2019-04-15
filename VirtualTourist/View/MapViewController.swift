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
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var fetchedResultController:NSFetchedResultsController<Pin>!
    var annotations: [MKAnnotation] = [MKAnnotation]()
    var pins: [Pin] = [Pin]()
    var selectedPin: Pin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMapview()
        // Do any additional setup after loading the view, typically from a nib.
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
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            let touchPoint: CGPoint = gestureReconizer.location(in: mapView)
            let touchCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            mapView.addAnnotation(createPin(touchCoordinate))
            return
        }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            return
        }
    }

}

//MARK: Saving of pin
extension MapViewController {
    
    func createPin(_ location: CLLocationCoordinate2D) -> Pin {
        let dataController = delegate.dataController
        let pin: Pin = Pin(latitude: location.latitude, longitude: location.longitude, dataController.viewContext)
        try? dataController.viewContext.save()
        selectedPin = pin
        performSegue(withIdentifier: "detail", sender: self)
        return pin
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detail") {
            let collectionVC = segue.destination as! PhotoCollectionViewController
            collectionVC.selectedPin = self.selectedPin
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
        selectedPin = view.annotation as? Pin
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    func fetchPins() -> [Pin] {
        let dataController = delegate.dataController
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
}
