//
//  DetailsVariant.swift
//  SampleApp
//
//  Created by Daniel Velikov on 17.02.24.
//

import Foundation

enum DetailsVariant {
    case condensed
    case full
    
    var displayText: String {
        switch self {
        case .condensed:
            return "Show all"
        case .full:
            return "Show relevant"
        }
    }
    
    mutating func toggle() {
        switch self {
        case .condensed:
            self = .full
        case .full:
            self = .condensed
        }
    }
}
