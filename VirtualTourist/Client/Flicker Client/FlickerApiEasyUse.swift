//
//  FlickerApiEasyUSe.swift
//  VirtualTourist
//
//  Created by Eli Warner on 4/8/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation
import UIKit

extension FlickerApi {
    
    class func getImagesFromLatLon(lat: Double, long: Double, completion: @escaping(_ result: [Pin]?, Error?, Double, Double)-> Void){
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
                completion(nil, error, lat, long)
                return
            }
            var photos: [Photo] = [Photo]()
            for result in results {
                
            }
            
            print(result)
            completion(result, nil, lat, long)
            
        }
        
    }
    

    
}