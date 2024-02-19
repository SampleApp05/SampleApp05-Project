//
//  DividerModifier.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//
import SwiftUI

struct DividerModifier: ViewModifier {
    private let color: Color
    private let spacing: CGFloat
    private let height: CGFloat
    
    init(color: Color = .white, spacing: CGFloat = 8, height: CGFloat = 1) {
        self.color = color
        self.spacing = spacing
        self.height = height
    }
    
    func body(content: Content) -> some View {
        VStack(spacing: spacing) {
            content
            Divider()
                .frame(height: height)
                .background(color)
        }
    }
}
