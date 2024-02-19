//
//  AuthVariant.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.02.24.
//

import Foundation

enum AuthVariant {
    case signIn
    case register
    
    var welcomeText: String {
        switch self {
        case .signIn:
            return "Welcome Back!"
        case .register:
            return "Welcome"
        }
    }
    
    var footerText: String {
        switch self {
        case .signIn:
            return "No Account?"
        case .register:
            return "Have an Account?"
        }
    }
    
    var footerActionText: String {
        switch self {
        case .signIn:
            return "Register Now"
        case .register:
            return "Sign In now"
        }
    }
    
    mutating func toggle() {
        switch self {
        case .signIn:
            self = .register
        case .register:
            self = .signIn
        }
    }
}
