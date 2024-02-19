//
//  Account.swift
//  SampleApp
//
//  Created by Daniel Velikov on 13.02.24.
//

import Foundation
import FirebaseAuth

struct Account {
    enum Status {
        case hasSession
        case hasLocalData
        case noData
    }
    
    let user: User?
    let email: String?
    let isAdmin: Bool
    let alias: String?
}
