//
//  FlickerApiEasyUSe.swift
//  VirtualTourist
//
//  Created by Eli Warner on 4/8/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation
import UIKit

class FlickerApi {
    
     func getImagesFromLatLon(pin: Pin, lat: Double, long: Double, completion: @escaping(_ result: [Photo]?, Error?)-> Void){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let dataController = delegate.dataController
        let method: String = FlickerAPIConst.Methods.Search
        
        let boxLatLeft = lat - 1
        let boxLngLeft = long - 1
        let boxLatRight = lat + 1
        let boxLngRight = long + 1
        let bBox = "\(boxLngLeft),\(boxLatLeft),\(boxLngRight),\(boxLatRight)"
        
        let randomNum: UInt32 = arc4random_uniform(10)
        let randomPage: Int = Int(randomNum)
        let parameters = [
            FlickerAPIConst.ParameterKeys.PerPage: 10,
            FlickerAPIConst.ParameterKeys.BBox: bBox,
            FlickerAPIConst.ParameterKeys.Format: "json",
            FlickerAPIConst.ParameterKeys.Page: randomPage
            ] as [String : AnyObject]

        taskForGETMethod(method, parameters: parameters) { (results, error) in
            guard let results = results else {
                print("Error: GetImagesFromLatLon threw error nil data")
                completion(nil, error)
                return
            }
            var photos: [Photo] = [Photo]()
            for result in results {
                let photo = Photo(title: result.title, flickrId: result.id, flickrUrl: result.flickerURL, data: nil, dataController.viewContext )
                photo.pin = pin
                photos.append(photo)
            }
            
            print(photos)
            completion(photos, nil)
            
        }
        
    }
    

    
}
