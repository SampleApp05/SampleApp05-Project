//
//  UIContextualAction+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 18.02.24.
//

import UIKit

extension UIContextualAction {
    enum Variant {
        case delete
        case edit
        
        var style: UIContextualAction.Style {
            switch self {
            case .delete:
                return .destructive
            case .edit:
                return .normal
            }
        }
        
        var image: UIImage? {
            switch self {
            case .delete:
                return .init(systemName: "trash")
            case .edit:
                return .init(systemName: "pencil")
            }
        }
        
        var background: UIColor {
            switch self {
            case .delete:
                return .red
            case .edit:
                return .main
            }
        }
    }
    
    static func swipeAction(for variant: Variant, action: @escaping ReturnItemClosure<Bool>) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: nil) { (_, _, completion) in
            completion(action())
        }
        
        action.image = variant.image
        action.backgroundColor = variant.background
        return action
    }
    
    static func delete(action: @escaping ReturnItemClosure<Bool>) -> UIContextualAction {
        swipeAction(for: .delete, action: action)
    }
    
    static func edit(action: @escaping ReturnItemClosure<Bool>) -> UIContextualAction {
        swipeAction(for: .edit, action: action)
    }
}
