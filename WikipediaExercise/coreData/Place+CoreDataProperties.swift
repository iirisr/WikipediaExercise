//
//  Place+CoreDataProperties.swift
//  WikipediaExercise
//
//  Created by Iris Ronen on 10/27/19.
//  Copyright © 2019 Iris Ronen. All rights reserved.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var image: String?
    @NSManaged public var summary: String
    @NSManaged public var title: String
    @NSManaged public var belongTo: Search

}
