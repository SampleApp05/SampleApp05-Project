//
//  RestaurantDetailsViewModel.swift
//  SampleApp
//
//  Created by Daniel Velikov on 15.02.24.
//

import UIKit

class RestaurantDetailsViewModel: CoordinatorModel {
    typealias DisplayReview = (variant: ReviewVariant, review: ReviewData)
   
    private let service: CoreDataService
    private var reviews: [ReviewData] = []
    private var detailsVariant: DetailsVariant
    let isAdmin: Bool
    let restaurant: Restaurant
    weak var coordinator: RestaurantFlowCoordinator?
    
    var filterButtonText: String { detailsVariant.displayText }
    
    var data: [DisplayReview] {
        guard detailsVariant == .condensed, reviews.count > 1 else { return reviews.map { (variant: .plain, review: $0) } }
        
        let sorted = reviews.sorted(by: { $0.rating > $1.rating })
        var data: [DisplayReview] = [(variant: .positive, review: sorted.first!), (variant: .negative, review: sorted.last!)]
        
        if reviews.count > 2 { data.insert((variant: .latest, review: reviews.first!), at: 0) }
        
        return data
    }
    
    init(coordinator: RestaurantFlowCoordinator?, service: CoreDataService, restaurant: Restaurant, variant: DetailsVariant, isAdmin: Bool) {
        self.coordinator = coordinator
        self.service = service
        self.restaurant = restaurant
        self.detailsVariant = variant
        self.isAdmin = isAdmin
    }
    
    // MARK: - Public
    func fetchReviews() {
        reviews = service.fetchReviews(for: String(restaurant.id))
    }
    
    func didTapFilterButton() {
        detailsVariant.toggle()
    }
    
    func didTapDelete(at index: Int) {
        let review = reviews.remove(at: index)
        service.deleteReview(review)
    }
    
    func didTapEdit(at index: Int) {
        let review = reviews[index]
        coordinator?.navigate(to: .editReview(restaurant: restaurant, review: review))
    }
}
