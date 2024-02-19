//
//  ReviewVariant.swift
//  SampleApp
//
//  Created by Daniel Velikov on 17.02.24.
//

import UIKit

enum ReviewVariant {
    case plain
    case positive
    case negative
    case latest
    
    var tintColor: UIColor {
        switch self {
        case .plain:
            return .accent
        case .positive:
            return .accent
        case .negative:
            return .red
        case .latest:
            return .main
        }
    }
    
    var imageName: String {
        switch self {
        case .plain:
            return "text.bubble.fill"
        case .positive:
            return "hand.thumbsup.fill"
        case .negative:
            return "hand.thumbsdown.fill"
        case .latest:
            return "clock.fill"
        }
    }
}
