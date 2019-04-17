//
//  PhotoCollectionViewController.swift
//  VirtualTourist
//
//  Created by Eli Warner on 4/14/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit
import MapKit
import CoreData

private let reuseIdentifier = "DetailCell"

class PhotoCollectionViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBAction func newCollectionButton(_ sender: UIButton) {
        loadPhotos()
    }
    @IBOutlet weak var newCollectionButtonOutlet: UIButton!
    // Pin he was als making out with his
    var selectedPin: Pin?
    // FlickrPhotos
    var photos: [Photo] = [Photo]()
    // Data Contoller
    var dataController: DataController!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializers()
        
        if (selectedPin?.photos?.count)! <= 0 {
            newCollectionButtonOutlet.isEnabled = false
            loadPhotos()
        } else {
            photos = (selectedPin?.photos)!.allObjects as! [Photo]
            newCollectionButtonOutlet.isEnabled = true
        }
    }
    
    // MARK: Fetch Photos
    func loadPhotos() {
        guard let pin = selectedPin else {
            print("Error in selectedPin")
            return
        }
        FlickerApi.getImagesFromLatLon(pin: pin, lat: pin.latitude, long: pin.longitude) { (result, error) in
            guard let result = result else {
                print("Error in Result from ImagePin")
                return
            }
            self.photos = result
            print("Start Of Printing Self.Photos: -------- \(self.photos)")
                DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
                }
            //print("Start for printing Result: ------------- \(result)")
        }
        newCollectionButtonOutlet.isEnabled = true
    }
    
    //MARK: Initializers
    func initializers(){
        mapView.delegate = self
        mapView.addAnnotation(selectedPin!)
        mapView.centerCoordinate = selectedPin!.coordinate
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = false
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self

    }
}
    // MARK: MKMapViewDelegate
extension PhotoCollectionViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.animatesDrop = false
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}

    // MARK: CollectionView Extension
extension PhotoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    //TODO: Make a photoViewCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionCell
        let flickerPhoto = photos[indexPath.row]
        let photoURL = flickerPhoto.flickrUrl!
        cell.startLoading()
        // Checking if flicker data is present allready
        if let flickerData = flickerPhoto.data {
            let image = UIImage(data: flickerData as Data)
            cell.imageView.image = image
            cell.stopLoading()
        } else {
            //No Flicker data, Start dataTask
            cell.startLoading()
            let _ = FlickerApi.getImagesFromURL(filePath: photoURL) { (data, error) in
                guard let imageData = data else {
                    print("Unable to Load Image: Cell #\(indexPath.row)")
                    return
                }
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                    flickerPhoto.data = imageData as NSData
                    cell.stopLoading()
                    try? self.dataController.viewContext.save()
                    cell.imageView.image = image
                    }
                } else {
                    print("Unable to get imageData")
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        photos.remove(at: indexPath.row)
        dataController.viewContext.delete(photo)
        imageCollectionView.reloadData()
    }
    
    
}

