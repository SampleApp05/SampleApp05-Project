//
//  RestaurantData+CoreDataProperties.swift
//  SampleApp
//
//  Created by Daniel Velikov on 19.02.24.
//
//

import Foundation
import CoreData


extension RestaurantData {
    @NSManaged public var restaurantID: String?
    @NSManaged public var reviews: NSSet?

}

// MARK: Generated accessors for reviews
extension RestaurantData {
    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: ReviewData)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: ReviewData)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}
