//
//  Auth+AuthenticationService.swift
//  SampleApp
//
//  Created by Daniel Velikov on 13.02.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

enum AccountDetailsKey: String {
    case isAdmin
    case alias
}

enum AuthError {
    case storePermissionsFailed
    case custom(Error)
}

extension Auth: AuthenticationService {
    private var service: Auth { Auth.auth() }
    
    private var usersReference: DatabaseReference { Database.database().reference().child("users") }
    
    func register(email: String, password: String, alias: String, isAdmin: Bool) async throws -> Account {
        let result = try await service.createUser(withEmail: email, password: password)
        
        let details: [String: Any] = [
            "isAdmin": isAdmin,
            "alias": alias
        ]
        
        try await storeAccountDetails(id: result.user.uid, data: details)
        
        UserDefaults.store(data: email, key: .email)
        UserDefaults.store(data: alias, key: .alias)
        
        return .init(user: result.user, email: email, isAdmin: isAdmin, alias: alias)
    }
    
    func signIn(email: String, password: String) async throws -> Account {
        let result = try await service.signIn(withEmail: email, password: password)
        let details = try await fetchAccountDetails(id: result.user.uid)
        
        let isAdmin = details[AccountDetailsKey.isAdmin.rawValue] as? Bool == true
        let alias = details[AccountDetailsKey.alias.rawValue] as? String ?? ""
        
        UserDefaults.store(data: email, key: .email)
        UserDefaults.store(data: alias, key: .alias)
        
        return .init(user: result.user, email: email, isAdmin: isAdmin, alias: alias)
    }
    
    func storeAccountDetails(id: String, data: [String: Any]) async throws {
        try await usersReference.child(id).setValue(data)
    }
    
    func fetchAccountDetails(id: String) async throws -> [String: Any] {
        try await usersReference.child(id).getData().value as? [String: Any] ?? [:]
    }
    
    func fetchAllAcountDetails() async throws -> [UserDetails] {
        let data = try await usersReference.getData().value as? [String: [String: Any]] ?? [:]
        
        let details: [UserDetails?] = data.map {
            guard let alias = $0.value["alias"] as? String, let isAdmin = $0.value["isAdmin"] as? Bool else { return nil }
            return UserDetails(id: $0.key, alias: alias, isAdmin: isAdmin)
        }
        
        return details.compactMap { $0 }
    }
}
