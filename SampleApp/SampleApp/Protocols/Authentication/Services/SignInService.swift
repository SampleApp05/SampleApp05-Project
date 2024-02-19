//
//  SignInService.swift
//  SampleApp
//
//  Created by Daniel Velikov on 13.02.24.
//

import Foundation

protocol SignInService: AnyObject {
    func signIn(email: String, password: String) async throws -> Account
    func fetchAccountDetails(id: String) async throws -> [String: Any]
//    func fetchPermission<T: Decodable>(id: String, key: PermissionKey) async throws -> T?
}
