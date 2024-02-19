//
//  String+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 5.02.24.
//

import Foundation

extension String {
    var isNotEmpty: Bool { isEmpty == false && self != "" }
    
    var toDouble: Double? { Double(self) }
}

extension Optional where Wrapped == String {
    var isNotEmpty: Bool { self?.isEmpty == false }
    
    var toDouble: Double? {
        guard let self = self else { return nil }
        return self.toDouble
    }
}
