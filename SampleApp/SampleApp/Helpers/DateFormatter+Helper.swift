//
//  DateFormatter+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 16.02.24.
//

import Foundation

extension DateFormatter {
    static var shortDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .init(secondsFromGMT:0)
        
        return formatter
    }
}
