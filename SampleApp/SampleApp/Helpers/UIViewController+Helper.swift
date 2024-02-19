//
//  UIViewController+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 5.02.24.
//

import UIKit

extension UIViewController {
    static var identifier: String { "\(Self.self)" }
    
    func onMain(deadline: DispatchTime? = nil, _ completion: @escaping VoidClosure) {
        guard let deadline = deadline else {
            DispatchQueue.main.async(execute: completion)
            return
        }
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: completion)
    }
    
    
    func presentAlert(config: AlertConfig) {
        let alert = UIAlertController(title: config.title, message: config.message, preferredStyle: .alert)
        
        config.actions.forEach {
            alert.addAction(.init(title: $0.text, style: $0.style, handler: $0.action))
        }
        
        onMain { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}
