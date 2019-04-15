//
//  FlickerAPI.swift
//  VirtualTourist
//
//  Created by Eli Warner on 4/7/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation


extension FlickerApi {
    

    //TODO: Return an object of FlickerPhoto
     func taskForGETMethod(_ method: String, parameters: [String : AnyObject], completion: @escaping (_ result: [FlickerPhoto]?, _ error: Error?) -> Void) -> URLSessionDataTask {
        var parametersWithApiKey = parameters
        parametersWithApiKey[FlickerAPIConst.ParameterKeys.Method] = method as AnyObject
        parametersWithApiKey[FlickerAPIConst.ParameterKeys.Callback] = "1" as AnyObject
        parametersWithApiKey[FlickerAPIConst.ParameterKeys.ApiKey] = FlickerAPIConst.ApiKey as AnyObject
        
        let request = URLRequest(url: flickrURLFromParameters(parametersWithApiKey, withPathExtension: ""))
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("Entered Error State In TaskForGetMethod")
                completion(nil, error)
                return
            }
            print(data)
            self.serializeDataFromGet(data: data, completion: completion)
        }
        task.resume()
        return task
    }
    
    //Serialize the FLicker Image Type Instead. 
     func serializeDataFromGet(data: Data, completion:@escaping(_ result: [FlickerPhoto]?, Error?)-> Void){
        
        let jsonDecoder = JSONDecoder()
        do {
            let parseResult = try jsonDecoder.decode(ResponseFlickerImage.self, from: data)
            var flickerArray: [FlickerPhoto] = []

            var i = 0
            print("Total Count of Recived Images: \(parseResult.photos.photo.count)")
            while i < parseResult.photos.photo.count {
                var currentResult = parseResult.photos.photo[i]
                flickerArray.append(currentResult)
                i += 1
            }
            
            completion(flickerArray, nil)
        } catch {
            print(error)
        }
    }
    
    
     func flickrURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = FlickerAPIConst.Constants.ApiScheme
        components.host = FlickerAPIConst.Constants.ApiHost
        components.path = FlickerAPIConst.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> FlickerApi {
        struct Singleton {
            static var sharedInstance = FlickerApi()
        }
        return Singleton.sharedInstance
    }
    
}
