//
//  CoordinatorModel.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import Foundation

@MainActor
protocol CoordinatorModel {
    associatedtype T: BaseCoordinator
    var coordinator: T? { get }
}
