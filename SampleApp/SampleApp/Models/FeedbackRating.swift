//
//  FeedbackRating.swift
//  SampleApp
//
//  Created by Daniel Velikov on 18.02.24.
//

import Foundation

enum FeedbackRating: Int, CaseIterable, Comparable {
    static public func < (lhs: FeedbackRating, rhs: FeedbackRating) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case terrible = 1
    case bad
    case neutral
    case good
    case excellent
    
    var emoji: String {
        switch self {
        case .terrible:
            return "😒"
        case .bad:
            return "🙁"
        case .neutral:
            return "🙂"
        case .good:
            return "😁"
        case .excellent:
            return "😍"
        }
    }
}
