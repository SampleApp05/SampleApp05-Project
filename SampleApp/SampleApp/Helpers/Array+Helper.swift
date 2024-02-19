//
//  Array+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 2.02.24.
//

import Foundation

extension Array where Element == BaseCoordinator {
    mutating func remove(_ element: BaseCoordinator) {
        guard let index = firstIndex(where: { $0 === element }) else { return }
        remove(at: index)
    }
}
