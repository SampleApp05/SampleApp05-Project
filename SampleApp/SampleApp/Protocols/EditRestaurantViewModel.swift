//
//  EditRestaurantViewModel.swift
//  SampleApp
//
//  Created by Daniel Velikov on 18.02.24.
//

import UIKit

protocol EditRestaurantViewModel: CoordinatorModel, AnyObject {
    var restaurants: [Restaurant] { get set }
    var selectedRestaurant: Restaurant? { get set}
    var editingName: String? { get set }
    var editingRating: Double? { get set }
    var newLogoImage: UIImage? { get set }
    var restaurantService: RestaurantDataService { get }
    var coreDataService: CoreDataService { get }
    var canSubmitReview: Bool { get }
    
    func didTapSubmitReviewButton()
    
    func fetchPhoto(for path: String?) async -> UIImage?
}

extension EditRestaurantViewModel {
    var canSubmitReview: Bool {
        guard let name = editingName, let rating = editingRating, name.isNotEmpty, (1.0...5.0).contains(rating) else { return false }
        
        return newLogoImage != nil ? true : editingName != selectedRestaurant?.name || editingRating != selectedRestaurant?.rating
    }
    
    func didTapSubmitReviewButton() {
        guard let name = editingName, let rating = editingRating else {
            return
        }
        
        let imageName = selectedRestaurant?.url ?? ("\(name.replacingOccurrences(of: " ", with: "").lowercased())")
        
        Task {
            var updatedRestaurants = restaurants
            var restaurantId: String
            if let restaurant = selectedRestaurant {
                guard let index = restaurants.firstIndex(where: { $0.id == restaurant.id }) else { return }
                restaurantId = restaurant.id
                
                let newRestaurant = Restaurant(id: restaurant.id, name: name, url: restaurant.url, rating: rating)
                updatedRestaurants.remove(at: index)
                updatedRestaurants.insert(newRestaurant, at: index)
            } else {
                restaurantId = UUID().uuidString
                updatedRestaurants.append(
                    .init(
                        id: restaurantId,
                        name: name,
                        url: imageName,
                        rating: rating
                    )
                )
                updatedRestaurants.sort(by: { $0.rating > $1.rating })
            }
            
            if let image = newLogoImage { try await restaurantService.storeRestaurantPhoto(image: image, name: imageName) }
            
            do {
                try await restaurantService.storeRestaurants(updatedRestaurants)
            } catch {
                print("Error storing restaurant: \(error.localizedDescription)")
                
                selectedRestaurant = nil
                coordinator?.popBack()
            }
            
            coreDataService.storeRestaurant(id: restaurantId)
            restaurants = updatedRestaurants
            selectedRestaurant = nil
            coordinator?.popBack()
        }
    }
}
