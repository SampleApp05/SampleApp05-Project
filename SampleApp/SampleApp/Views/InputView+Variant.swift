//
//  InputView+Variant.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import SwiftUI

extension InputView {
    enum Variant: Hashable {
        case plain
        case secure
        case numeric
        case email
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .plain, .secure:
                return .alphabet
            case .numeric:
                return .decimalPad
            case .email:
                return .emailAddress
            }
        }
    }
}
