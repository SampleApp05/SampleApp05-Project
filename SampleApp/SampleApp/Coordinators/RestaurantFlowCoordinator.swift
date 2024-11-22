//
//  HomeCoordinator.swift
//  SampleApp
//
//  Created by Daniel Velikov on 15.02.24.
//

import UIKit
import FirebaseDatabase

enum RestaurantFlow {
    case restaurantList
    case details(restaurant: Restaurant)
    case feedback(restaurant: Restaurant)
    case showAlert(config: AlertConfig)
    case editRestaurant
    case editReview(restaurant: Restaurant, review: ReviewData)
}

class RestaurantFlowCoordinator: BaseCoordinator {
    weak var parent: BaseCoordinator?
    var children: [BaseCoordinator] = []
    var navigationController: UINavigationController
    private(set) var restaurantsViewModel: RestaurantsViewModel?
    private let injected: Injected
    
    private var model: RestaurantsViewModel {
        guard let model = restaurantsViewModel else { fatalError("Must call configure method on HomeCoordiantor!") }
        return model
    }
    
    init(parent: BaseCoordinator?, navigationController: UINavigationController, injected: Injected) {
        self.parent = parent
        self.navigationController = navigationController
        self.injected = injected
    }
    
    func configure(with model: RestaurantsViewModel) {
        restaurantsViewModel = model
    }
    
    func start() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.main]
        navigationController.tabBarItem = .init(title: "Home", image: .init(systemName: "house"), selectedImage: .init(systemName: "house.fill"))
        
        #warning("Edit homeController to view SwiftUI/UIKit versions")
        let homeController = HostController<RestaurantListView>(model: model)
        //let homeController = RestaurantListViewController(model: model)
        
        navigationController.pushViewController(homeController, animated: true)
    }
    
    func navigate(to destination: RestaurantFlow) {
        switch destination {
        case .restaurantList:
            navigationController.popToRoot()
        case let .details(restaurant):
            let model = RestaurantDetailsViewModel(
                coordinator: self,
                service: injected.coreDataService,
                restaurant: restaurant,
                variant: .full,
                isAdmin: injected.account?.isAdmin == true
            )
            let controller = RestaurantDetailsController(model: model)
            navigationController.push(controller)
        case let .feedback(restaurant):
            let feedbackModel = FeedbackViewModel(coordinator: self, variant: .add(restaurant: restaurant), service: injected.coreDataService)
            let controller = HostController<FeedbackView>(model: feedbackModel)
            
            present(controller)
        case let .showAlert(config):
            navigationController.presentAlert(config: config)
        case .editRestaurant:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                let controller = EditRestaurantController(model: model)
                navigationController.push(controller)
            }
        case let .editReview(restaurant, review):
            let feedbackModel = FeedbackViewModel(coordinator: self, variant: .edit(restaurant: restaurant, review: review), service: injected.coreDataService)
            let controller = HostController<FeedbackView>(model: feedbackModel)
            
            navigationController.push(controller)
        }
    }
}
