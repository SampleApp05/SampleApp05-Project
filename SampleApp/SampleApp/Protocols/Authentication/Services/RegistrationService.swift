//
//  RegistrationService.swift
//  SampleApp
//
//  Created by Daniel Velikov on 13.02.24.
//

import Foundation

protocol RegistrationService: AnyObject {
    func register(email: String, password: String, alias: String, isAdmin: Bool) async throws -> Account
    func storeAccountDetails(id: String, data: [String: Any]) async throws
    func fetchAllAcountDetails() async throws -> [UserDetails]
}
