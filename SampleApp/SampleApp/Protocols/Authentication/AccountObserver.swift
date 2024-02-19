//
//  AccountObserver.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.02.24.
//

import Foundation

protocol AccountObserver: AnyObject {
    func accountUpdated(with account: Account)
    func accountLoggedOut()
}
