//
//  EnvironmentValues+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import SwiftUI

struct LoadingKey: EnvironmentKey {
    static let defaultValue = false
}

struct ProxySizeKey: EnvironmentKey {
    static let defaultValue = CGSize.zero
}

extension EnvironmentValues {
    var isLoading: Bool {
        get { self[LoadingKey.self] }
        set { self[LoadingKey.self] = newValue }
    }
    
    var proxySize: CGSize {
        get { self[ProxySizeKey.self] }
        set { self[ProxySizeKey.self] = newValue }
    }
}
