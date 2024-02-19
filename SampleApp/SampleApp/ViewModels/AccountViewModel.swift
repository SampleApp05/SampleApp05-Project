//
//  AccountViewModel.swift
//  SampleApp
//
//  Created by Daniel Velikov on 15.02.24.
//

import Foundation

class AccountViewModel: CoordinatorModel, ObservableObject {
    weak var coordinator: AppCoordinator?
    private let injected: Injected
    
    @Published var status: RequestStatus = .notStarted
    
    var email: String { injected.email ?? "Missing Email"}
    var alias: String { injected.alias ?? "Missing Alias"}
    var uuid: String { injected.uuid }
    
    init(coordinator: AppCoordinator?, injected: Injected) {
        self.coordinator = coordinator
        self.injected = injected
    }
    
    func signOut() {
        guard status != .inProgress else { return }
        
        do {
            try injected.authService.signOut()
            status = .success
            coordinator?.accountLoggedOut()
            coordinator?.finish()
        } catch {
            status = .error
        }
    }
}
