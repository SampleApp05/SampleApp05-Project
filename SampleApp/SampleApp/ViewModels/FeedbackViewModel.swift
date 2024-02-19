//
//  FeedbackViewModel.swift
//  SampleApp
//
//  Created by Daniel Velikov on 16.02.24.
//

import SwiftUI

class FeedbackViewModel: CoordinatorModel, ObservableObject {
    enum Variant {
        case add(restaurant: Restaurant)
        case edit(restaurant: Restaurant, review: ReviewData)
        
        var restaurant: Restaurant {
            switch self {
            case let .add(restaurant):
                return restaurant
            case let .edit(restaurant, _):
                return restaurant
            }
        }
        
        var rating: Double {
            switch self {
            case .add:
                return 0.0
            case let .edit(_, review):
                return review.rating
            }
        }
        
        var comment: String {
            switch self {
            case .add:
                return ""
            case let .edit(_, review):
                return review.comment
            }
        }
        
        var ignoreEdgeInsets: Edge.Set {
            switch self {
            case .add:
                return .all
            case .edit:
                return .horizontal
            }
        }
    }
    
    let characterLimit: Int
    let variant: Variant
    let service: CoreDataService
    weak var coordinator: RestaurantFlowCoordinator?
    
    @Published var requestStatus = RequestStatus.notStarted
    @Published var displayRating: FeedbackRating?
    @Published var rating = 0.0
    @Published var comment = ""
    
    var remainingCharecters: Int { characterLimit - comment.count }
    
    public init(coordinator: RestaurantFlowCoordinator?, variant: Variant, service: CoreDataService, characterLimit: Int = 150) {
        self.coordinator = coordinator
        self.variant = variant
        self.service = service
        self.characterLimit = characterLimit
        
        rating = variant.rating
        comment = variant.comment
    }
    
    // MARK: - Public
    func submitReviewIfPossible() {
        switch variant {
        case .add:
            addReview()
        case let.edit(_, review):
            updateReview(review: review)
        }
    }
    
    func addReview() {
        guard requestStatus != .inProgress else { return }
        
        requestStatus = .inProgress
        service.saveReview(restaurantId: variant.restaurant.id, rating: rating, comment: comment)
        requestStatus = .success
        coordinator?.dismiss()
    }
    
    func updateReview(review: ReviewData) {
        guard requestStatus != .inProgress else { return }
        
        requestStatus = .inProgress
        service.updateReview(review, rating: rating, comment: comment)
        requestStatus = .success
        coordinator?.navigate(to: .restaurantList)
    }
}
