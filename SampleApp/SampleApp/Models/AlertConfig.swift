//
//  AlertConfig.swift
//  SampleApp
//
//  Created by Daniel Velikov on 17.02.24.
//

import Foundation

struct AlertConfig {
    let title: String?
    let message: String?
    let actions: [AlertAction]
    
    init(title: String?, message: String?, actions: [AlertAction]) {
        self.title = title
        self.message = message
        self.actions = actions
    }
}
