//
//  UserDefaults+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import Foundation

extension UserDefaults {
    enum Key: String {
        case email
        case alias
    }
    
    static func store<T: Encodable>(data: T, key: Key) {
        guard let data = try? JSONEncoder().encode(data) else { return }
        standard.set(data, forKey: key.rawValue)
    }
    
    static func read<T: Decodable>(key: Key) -> T? {
        guard let data = standard.data(forKey: key.rawValue) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
