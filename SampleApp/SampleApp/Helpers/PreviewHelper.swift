//
//  PreviewHelper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 22.11.24.
//

import Foundation

extension Injected {
    static let mock: Injected = .init(
        account: .init(
            user: nil,
            email: UserDefaults.read(key: .email),
            isAdmin: false,
            alias: UserDefaults.read(key: .alias)
        ),
        authService: .auth(),
        restaurantService: RestaurantService(),
        coreDataService: .init(container: .init(name: "RestaurantReviewsData"))
    )
}
