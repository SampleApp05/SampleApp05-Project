//
//  AuthenticationService.swift
//  SampleApp
//
//  Created by Daniel Velikov on 13.02.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationService: SignInService, RegistrationService {
    func signOut() throws
}
