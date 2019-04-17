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
    
     class func getImagesFromLatLon(pin: Pin, lat: Double, long: Double, completion: @escaping(_ result: [Photo]?, Error?)-> Void){
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
            var photos: [Photo] = []
            print("Result Count \(results.count)")
            for result in results {
            let photo: Photo = Photo(title: result.title, flickrId: result.id, flickrUrl: result.flickerURL, data: nil, dataController.viewContext )
                photo.pin = pin
                photos.append(photo)
            }
            completion(photos, nil)
        }
    }
    
    class func getImagesFromURL(filePath: String, completion: @escaping (_ imageData: Data?, _ error: Error?) -> Void) -> URLSessionTask {
        let url = URL(string: filePath)!
        
        var task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("GETTASKFROMRURL: ----- Unable to get images")
                completion(nil, error)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
        task.resume()
        return task
        
    }
    

    
}
