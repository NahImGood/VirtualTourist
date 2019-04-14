//
//  ResponseFlickerImage.swift
//  VirtualTourist
//
//  Created by Eli Warner on 4/10/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation

struct ResponseFlickerImage: Decodable {
    let photos: Photos
}

struct Photos: Decodable {
    let page: Int
    let pages: Double
    let perpage: Int
    let photo: [FlickerPhoto]
}

struct FlickerPhoto: Decodable {
    let farm: Int
    let id: String
    let isfamily: Int
    let ispublic: Int
    let owner: String
    let secret: String
    let server: String
    let title: String
    
    var flickerURL: URL {
        get {
            return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(self.id)_\(secret).jpg")!
        }
    }
    
    enum CodingKeys: CodingKey {
        case farm
        case id
        case isfamily
        case ispublic
        case owner
        case secret
        case server
        case title
        
    }
}

/*
 photos =     {
                 page = 7;
                 pages = 21304;
                 perpage = 10;
                 photo =         (
                                 {
                                 farm = 8;
                                 id = 47581536131;
                                 isfamily = 0;
                                 isfriend = 0;
                                 ispublic = 1;
                                 owner = "30607051@N00";
                                 secret = 3b91907967;
                                 server = 7814;
                                 title = "united flight ua926 taxis to departure to frankfurt";
                                 },
 */
