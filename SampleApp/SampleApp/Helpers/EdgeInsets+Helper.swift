//
//  EdgeInsets+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import SwiftUI

extension EdgeInsets {
    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}
