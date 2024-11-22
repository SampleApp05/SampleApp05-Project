//
//  Restaurant.swift
//  SampleApp
//
//  Created by Daniel Velikov on 15.02.24.
//

import Foundation

struct Restaurant: Codable, Equatable, Identifiable {
    let id: String
    var name: String
    let url: String
    var rating: Double
    
    var displayRating: String { String(format: "%.1f", rating) }
    
    var asJson: [String: Any] { ["id": id, "name": name, "url": url, "rating": rating] }
}
