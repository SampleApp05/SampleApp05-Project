//
//  RestaurantsViewModel.swift
//  SampleApp
//
//  Created by Daniel Velikov on 15.02.24.
//

import UIKit
import Photos

@Observable
final class RestaurantsViewModel: CoordinatorModel, EditRestaurantViewModel, ObservableObject {
    private(set) var requestStatus: RequestStatus = .notStarted
    let injected: Injected
    var editingName: String?
    var editingRating: Double?
    var newLogoImage: UIImage?
    var selectedRestaurantImage: UIImage?
    
    var restaurants: [Restaurant] = [] {
        didSet { delegate?.shouldReloadData() }
    }
    var selectedRestaurant: Restaurant? {
        didSet {
            guard selectedRestaurant != oldValue else { return }
            editingName = selectedRestaurant?.name
            editingRating = selectedRestaurant?.rating
        }
    }
    
    weak var coordinator: RestaurantFlowCoordinator?
    weak var delegate: RestaurantViewModelDelegate?
    
    var restaurantService: RestaurantDataService { injected.restaurantService }
    var coreDataService: CoreDataService { injected.coreDataService }
    
    var shouldShowLoadingView: Bool { requestStatus == .inProgress  && restaurants.isEmpty }
    
    var swipeActions: [UIContextualAction.Variant] {
        guard injected.account?.isAdmin == true else { return [] }
        
        return UIContextualAction.Variant.allCases
    }
    
    init(coordinator: RestaurantFlowCoordinator? = nil, injeted: Injected) {
        self.coordinator = coordinator
        self.injected = injeted
    }
    
    // MARK: - Private
    private func requestPhotosAccessIfNeeded() async -> Bool {
        let photosAccessStatus = PHPhotoLibrary.authorizationStatus()
        
        if photosAccessStatus == .restricted { return false }
        guard photosAccessStatus == .notDetermined || photosAccessStatus == .denied else { return true }
        
        let status = await withCheckedContinuation { (continuation) in
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
                continuation.resume(returning: status)
            }
        }
        
        return status != .notDetermined && status != .denied && status != .restricted
    }
    
    // MARK: - Public
    func fetchRestaurants() async {
        guard requestStatus != .inProgress else { return }
        requestStatus = .inProgress
        
        do {
            restaurants = try await restaurantService.fetchRestaurants().sorted(by: { $0.rating > $1.rating })
            requestStatus = .success
        } catch {
            requestStatus = .error
        }
    }
    
    func fetchPhoto(for path: String? = nil) async -> UIImage? {
        guard let path = path ?? selectedRestaurant?.url else { return nil }
        return try? await restaurantService.fetchPhoto(path: path)
    }
    
    func imageURL(for path: String) async -> URL? {
        await restaurantService.imageURL(for: path)
    }
    
    func deleteRestaurant(at index: Int) {
        guard requestStatus != .inProgress else { return }
        requestStatus = .inProgress
        
        Task {
            var tempRestaurants = restaurants
            let removed = tempRestaurants.remove(at: index)
            
            do {
                try await restaurantService.storeRestaurants(tempRestaurants)
                restaurants = tempRestaurants
                coreDataService.deleteRetaurant(removed)
                requestStatus = .success
            } catch {
                requestStatus = .error
            }
        }
    }
    
    func editRestaurant(at index: Int) {
        selectedRestaurant = restaurants[index]
        selectedRestaurantImage = .init(systemName: "trash")
        DispatchQueue.main.async { [weak self] in
            self?.coordinator?.navigate(to: .editRestaurant)
        }
    }
    
    func didTapCell(at index: Int) {
        coordinator?.navigate(to: .details(restaurant: restaurants[index]))
    }
    
    func showRestaurantDetails(for restaurant: Restaurant) {
        coordinator?.navigate(to: .details(restaurant: restaurant))
    }
    
    func showRestaurantFeedback(for restaurant: Restaurant) {
        coordinator?.navigate(to: .feedback(restaurant: restaurant))
    }
    
    func swipeAction(for variant: UIContextualAction.Variant, restaurant: Restaurant) {
        guard let index = restaurants.firstIndex(of: restaurant) else { return }
        
        switch variant {
        case .edit:
            editRestaurant(at: index)
        case .delete:
            deleteRestaurant(at: index)
        }
    }
    
    func didTapAddButton() {
        Task {
            guard await requestPhotosAccessIfNeeded() else {
                coordinator?.navigate(
                    to: .showAlert(
                        config: .init(
                            title: "Photo Access",
                            message: "Please allow access to photo library",
                            actions: [.cancel, .settings].compactMap { $0 }
                        )
                    )
                )
                
                return
            }
            
            coordinator?.navigate(to: .editRestaurant)
        }
    }
}
