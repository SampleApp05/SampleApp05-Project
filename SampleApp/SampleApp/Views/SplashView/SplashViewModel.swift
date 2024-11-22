//
//  SplashViewModel.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.02.24.
//

import Foundation
import FirebaseAuth

class SplashViewModel: CoordinatorModel, ObservableObject {
    enum Variant {
        case initial
        case auth
    }
    
    var splashVariant: Variant { (accountStatus == .hasSession || accountStatus == .hasLocalData) ? .auth : .initial }
    
    private let service: AuthenticationService
    private let accountStatus: Account.Status
    private let email: String?
    weak var coordinator: AppCoordinator?
    
    init(coordinator: AppCoordinator? = nil, service: AuthenticationService, accountStatus: Account.Status, email: String?) {
        self.coordinator = coordinator
        self.service = service
        self.accountStatus = accountStatus
        self.email = email
    }
    
    // MARK: - Private
    #warning("Adding a delay to make sure splash animation finishes. iOS 17+ allows animations with completion block in SwiftUI")
    private func navigateToLoginIfNeeded() {
        if accountStatus == .hasLocalData {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.coordinator?.navigate(to: .login)
            }
        }
    }
    
    // MARK: - Public
    public func navigateToNextScreen() {
        guard let user = Auth.auth().currentUser else {
            navigateToLoginIfNeeded()
            return
        }
        
        Task {
            do {
                let details = try await service.fetchAccountDetails(id: user.uid)
                coordinator?.accountUpdated(
                    with: .init(
                        user: user,
                        email: email,
                        isAdmin: details[AccountDetailsKey.isAdmin.rawValue] as? Bool ?? false,
                        alias: details[AccountDetailsKey.alias.rawValue] as? String ?? ""
                    )
                )
            } catch {
                try? service.signOut()
                navigateToLoginIfNeeded()
            }
        }
    }
}
