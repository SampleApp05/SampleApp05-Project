//
//  Double+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 18.02.24.
//

import Foundation

extension Double {
    var asFormattedStringDouble: String { String(format: "%.1f", self) }
}
