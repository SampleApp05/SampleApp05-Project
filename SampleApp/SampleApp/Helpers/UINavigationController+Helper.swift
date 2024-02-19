//
//  UINavigationController+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 18.02.24.
//

import UIKit

extension UINavigationController {
    func push(_ controller: UIViewController) {
        onMain { [weak self] in
            self?.pushViewController(controller, animated: true)
        }
    }
    
    func popBack() {
        onMain { [weak self] in
            self?.popViewController(animated: true)
        }
    }
    
    func popToRoot() {
        onMain { [weak self] in
            self?.popToRootViewController(animated: true)
        }
    }
}
