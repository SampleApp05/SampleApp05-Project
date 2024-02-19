//
//  CoordinatorModelView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import SwiftUI

protocol CoordinatorModelView: View {
    associatedtype T: CoordinatorModel & ObservableObject
    
    var model: T { get }
    
    init(model: T)
}

extension CoordinatorModelView {
    func onMain(_ action: @escaping VoidClosure) {
        Task {
            await MainActor.run { action() }
        }
    }
}
