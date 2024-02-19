//
//  ReviewData+CoreDataClass.swift
//  SampleApp
//
//  Created by Daniel Velikov on 19.02.24.
//
//

import Foundation
import CoreData

@objc(ReviewData)
public class ReviewData: NSManagedObject, Identifiable {
    @nonobjc public static var fetchRequest: NSFetchRequest<ReviewData> { NSFetchRequest<ReviewData>(entityName: "ReviewData") }
}
