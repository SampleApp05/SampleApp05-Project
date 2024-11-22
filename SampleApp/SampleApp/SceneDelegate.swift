//
//  SceneDelegate.swift
//  SampleApp
//
//  Created by Daniel Velikov on 2.02.24.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var authService = Auth.auth()
    private lazy var appCoordinator = AppCoordinator(
        navigationController: .init(),
        injected: .init(
            account: .init(
                user: authService.currentUser,
                email: UserDefaults.read(key: .email),
                isAdmin: false,
                alias: UserDefaults.read(key: .alias)
            ),
            authService: authService,
            restaurantService: RestaurantService(),
            coreDataService: .init(container: .init(name: "RestaurantReviewsData"))
        )
    )
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        appCoordinator.start()
        appCoordinator.navigationController.setNavigationBarHidden(true, animated: true)
        window?.rootViewController = appCoordinator.navigationController
        
        window?.makeKeyAndVisible()
    }
}
