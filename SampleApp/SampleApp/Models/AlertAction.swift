//
//  AlertAction.swift
//  SampleApp
//
//  Created by Daniel Velikov on 17.02.24.
//

import UIKit

struct AlertAction {
    static let cancel = AlertAction(text: "Cancel", style: .destructive)
    static let settings: AlertAction? = {
        guard let action = UIApplication.openSettingsAction else { return nil }
        return .init(text: "Settins", action: { _ in action() })
    }()
    
    let text: String
    let style: UIAlertAction.Style
    let action: ItemClosure<UIAlertAction>?
    
    init(text: String, style: UIAlertAction.Style = .default, action: ItemClosure<UIAlertAction>? = nil) {
        self.text = text
        self.style = style
        self.action = action
    }
}
