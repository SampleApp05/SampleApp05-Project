//
//  NSRegularExpression+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 13.02.24.
//

import Foundation

extension NSRegularExpression {
    static let email = NSRegularExpression(with: #"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"#)!
    
    convenience init?(with pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            print("Failed to create regex: \(error.localizedDescription)")
            return nil
        }
    }
    
    func matches(in text: String) -> Bool {
        let range = NSRange(location: 0, length: text.utf16.count)
        return firstMatch(in: text, options: [], range: range) != nil
    }
}
