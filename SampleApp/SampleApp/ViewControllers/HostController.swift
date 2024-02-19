//
//  HostController.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import SwiftUI

class HostController<T: CoordinatorModelView>: UIHostingController<T> {
    let model: T.T
    
    init(model: T.T) {
        self.model = model
        super.init(rootView: T(model: model))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
