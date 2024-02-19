//
//  Date+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 16.02.24.
//

import Foundation

extension Date {
    var shortPretty: String { DateFormatter.shortDateFormatter.string(from: self) }
}
