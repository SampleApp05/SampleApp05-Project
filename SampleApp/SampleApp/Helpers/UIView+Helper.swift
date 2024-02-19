//
//  UIView+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 5.02.24.
//

import UIKit

extension UIView {
    static var identifier: String { "\(Self.self)" }
    
    func centerInSuperview(insets: UIEdgeInsets) {
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
    func rounded(radius: CGFloat = 5) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func bordered(width: CGFloat = 0.5, color: UIColor = .accent) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}
