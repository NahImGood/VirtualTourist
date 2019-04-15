//
//  Photo+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Eli Warner on 4/14/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    convenience init(title: String, flickrId: String, flickrUrl: String, data: NSData?, _ context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            self.title = title
            self.flickrId = flickrId
            self.flickrUrl = flickrUrl
            self.data = data
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
