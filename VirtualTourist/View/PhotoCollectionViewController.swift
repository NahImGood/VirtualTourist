//
//  PhotoCollectionViewController.swift
//  VirtualTourist
//
//  Created by Eli Warner on 4/14/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit
import MapKit

private let reuseIdentifier = "DetailCell"

class PhotoCollectionViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    // Pin
    var selectedPin: Pin?
    // FlickrPhotos
    var photos: [Photo] = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        imageCollectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    // MARK: Fetch Photos
    func loadPhotos() {
        FlickerApi.sharedInstance().getImagesFromLatLon(pin: selectedPin!, lat: selectedPin!.latitude, long: selectedPin!.longitude) { (_ result: [Photo]?, _ error: Error?) in
            self.photos = result!
            print("print: results from LoadPhotos: ------------ \(result)")
                self.performUIUpdatesOnMain {
                    self.imageCollectionView.reloadData()
                }
            }
    }
    
    //MARK: Initializers
    func initializers(){
        mapView.delegate = self as! MKMapViewDelegate
    }

    
}

