//
//  AuthViewModel.swift
//  SampleApp
//
//  Created by Daniel Velikov on 13.02.24.
//

import Foundation

protocol AuthViewModel: CoordinatorModel & ObservableObject {
    associatedtype Service: AuthenticationService
    
    var service: Service { get }
    var accountObserver: AccountObserver? { get }
    
    var variant: AuthVariant { get set }
    var requestStatus: RequestStatus { get set }
    var email: String { get set }
    var alias: String { get set }
    var password: String { get set }
    var isAdmin: Bool { get set }
    var hasValidEmail: Bool { get set }
    var hasValidPassword: Bool { get set }
    var adminCode: String { get set }
    var hasValidAdminCode: Bool { get set }
    
    func register()
    func signIn()
    func authenticate()
    func signOut()
    func validate(_ credential: Credential)
    func resetInput()
    func isEnabled() -> Bool
}

extension AuthViewModel {
    func register() {
        guard requestStatus != .inProgress else { return }
        
        requestStatus = .inProgress
        
        Task {
            do {
                let account = try await service.register(email: email, password: password, alias: alias, isAdmin: isAdmin)
                accountObserver?.accountUpdated(with: account)
                requestStatus = .success
            } catch {
                print("Registration Error: \(error.localizedDescription)")
                requestStatus = .error
                try? service.signOut()
            }
        }
    }
    
    func signIn() {
        guard requestStatus != .inProgress else { return }
        
        requestStatus = .inProgress
        
        Task {
            do {
                let account = try await service.signIn(email: email, password: password)
                accountObserver?.accountUpdated(with: account)
                DispatchQueue.main.async { [weak self] in
                    self?.requestStatus = .success
                }
            } catch {
                print("Error signing in: \(error.localizedDescription)")
                DispatchQueue.main.async { [weak self] in
                    self?.requestStatus = .error
                }
            }
        }
    }
    
    func authenticate() {
        variant == .signIn ? signIn() : register()
    }
    
    func signOut() {
        guard requestStatus != .inProgress else { return }
        
        do {
            try service.signOut()
            requestStatus = .success
            accountObserver?.accountLoggedOut()
        } catch {
            requestStatus = .error
        }
    }
}
