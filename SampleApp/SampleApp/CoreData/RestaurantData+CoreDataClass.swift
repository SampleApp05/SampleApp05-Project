//
//  RestaurantData+CoreDataClass.swift
//  SampleApp
//
//  Created by Daniel Velikov on 19.02.24.
//
//

import Foundation
import CoreData

@objc(RestaurantData)
public class RestaurantData: NSManagedObject, Identifiable {
    @nonobjc public static var fetchRequest: NSFetchRequest<RestaurantData> { NSFetchRequest<RestaurantData>(entityName: "RestaurantData") }
}

