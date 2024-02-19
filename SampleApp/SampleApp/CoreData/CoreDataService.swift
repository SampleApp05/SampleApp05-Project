//
//  CoreDataService.swift
//  SampleApp
//
//  Created by Daniel Velikov on 16.02.24.
//

import Foundation
import CoreData

class CoreDataService {
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
        
        self.container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Core Data Unresolved error \(error), \(error.userInfo)")
            }
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        })
    }
    
    func storeRestaurant(id: String) {
        let restaurant = RestaurantData(context: container.viewContext)
        restaurant.restaurantID = id
        
        container.saveContext()
    }
    
    func saveReview(restaurantId: String, rating: Double, comment: String) {
        let restaurantReview = ReviewData(context: container.viewContext)
        restaurantReview.id = UUID().uuidString
        restaurantReview.restaurantID = restaurantId
        restaurantReview.rating = rating
        restaurantReview.comment = comment
        restaurantReview.date = Date()
        
        container.saveContext()
    }
    
    func updateReview(_ review: ReviewData, rating: Double, comment: String) {
        review.rating = rating
        review.comment = comment
        
        container.saveContext()
    }
    
    func fetchReviews(for restaurantId: String) -> [ReviewData] {
        let request = ReviewData.fetchRequest
        request.predicate = .init(format: "%K == %@", #keyPath(RestaurantData.restaurantID), restaurantId)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching reviews for restaurant: \(restaurantId). Message: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteRetaurant(_ data: Restaurant) {
        let restaurant = RestaurantData(context: container.viewContext)
        container.viewContext.delete(restaurant)
        container.saveContext()
    }
    
    func deleteReview(_ review: ReviewData) {
        container.viewContext.delete(review)
        container.saveContext()
    }
}
