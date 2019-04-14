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
    
    @IBOutlet weak var mapView: MKMapView!
    
    var dataController: DataController!
    var fetchedResultController:NSFetchedResultsController<Pin>!
    
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
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            FlickerApi.getImagesFromLatLon(lat:locationCoordinate.latitude, long: locationCoordinate.longitude, completion: handleImagesFromLatLon(images:error:lat:long:))
            return
        }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            return
        }
    }

}
//MARK: Saving of pin
extension MapViewController {
    
    func handleImagesFromLatLon(images: [FlickerPhoto]?, error: Error?, lat: Double, long: Double){
        //Convert FlickerPhoto to Pin
        
        var pin = Pin(context: dataController.viewContext)
        pin.latitude = lat
        pin.longitude = long
        
        print(pin)
        
    }
    
    func fetchImages(images: [FlickerPhoto]) -> [UIImage] {
        
        var image = [UIImage]()
        let group = DispatchGroup()
        let serialQueue = DispatchQueue(label: "serialQueue")
        
        var URLArray = fetchImageUrlList(urls: images)
        
        return image
        
    }
    
    func getImagesFromUrl(urls: [URL]) -> [UIImage]{
        var images: [UIImage] = []
        for url in urls {
            print(url)
        }
        return images
    }
    
    func fetchImageUrlList(urls: [FlickerPhoto])-> [URL]{
        var i = 0
        var returnedUrls: [URL] = []
        while i < urls.count {
           returnedUrls.append(urls[i].flickerURL)
        }
        print(returnedUrls)
        print(returnedUrls)
        return returnedUrls
        
    }
    
}
