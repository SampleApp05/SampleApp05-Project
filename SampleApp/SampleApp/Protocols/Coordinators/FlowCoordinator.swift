//
//  FlowCoordinator.swift
//  SampleApp
//
//  Created by Daniel Velikov on 14.02.24.
//

import Foundation

protocol FlowCoordinator: BaseCoordinator {
    associatedtype Destination: RawRepresentable
    func navigate(to destination: Destination)
}
