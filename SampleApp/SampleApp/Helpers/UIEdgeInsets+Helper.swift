//
//  UIEdgeInsets+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 15.02.24.
//

import UIKit

extension UIEdgeInsets {
    init(vertical: CGFloat, horizonal: CGFloat) {
        self.init(top: vertical, left: horizonal, bottom: vertical, right: horizonal)
    }
}
