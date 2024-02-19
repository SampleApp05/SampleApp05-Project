//
//  ReviewData+CoreDataProperties.swift
//  SampleApp
//
//  Created by Daniel Velikov on 19.02.24.
//
//

import Foundation
import CoreData


extension ReviewData {
    @NSManaged public var comment: String
    @NSManaged public var date: Date
    @NSManaged public var id: String
    @NSManaged public var rating: Double
    @NSManaged public var restaurantID: String
    @NSManaged public var restaurant: RestaurantData?

}
