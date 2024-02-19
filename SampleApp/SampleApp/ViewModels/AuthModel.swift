//
//  AuthModel.swift
//  SampleApp
//
//  Created by Daniel Velikov on 13.02.24.
//

import Foundation
import FirebaseAuth

class AuthModel<Service: AuthenticationService, Coordinator: BaseCoordinator & AccountObserver>: ObservableObject, AuthViewModel {
    let service: Service
    weak var coordinator: Coordinator?
    
    @Published var variant: AuthVariant = .signIn
    @Published var requestStatus: RequestStatus = .notStarted
    @Published var email: String
    @Published var password: String = ""
    @Published var alias: String = ""
    @Published var isAdmin: Bool = false
    @Published var adminCode: String = ""
    @Published var hasValidEmail = false
    @Published var hasValidPassword = false
    @Published var hasValidAdminCode = false
    
    var accountObserver: AccountObserver? { coordinator }
    
    init(coordinator: Coordinator?, service: Service, variant: AuthVariant, email: String?) {
        self.coordinator = coordinator
        self.service = service
        self.variant = variant
        self.email = email ?? ""
    }
    
    func validate(_ credential: Credential) {
        switch credential {
        case .email:
            hasValidEmail = NSRegularExpression.email.matches(in: email)
        case .password:
            hasValidPassword = password.count > 5
        case .adminPermission:
            hasValidAdminCode = adminCode == "1111"
        }
    }
    
    func resetInput() {
        email = ""
        password = ""
        adminCode = ""
        alias = ""
        isAdmin = false
    }
    
    func isEnabled() -> Bool {
        let hasValidAlias = variant == .register ? alias.isNotEmpty : true
        guard hasValidEmail && hasValidPassword, hasValidAlias else { return false }
        
        if isAdmin { return hasValidAdminCode }
        return true
    }
}
