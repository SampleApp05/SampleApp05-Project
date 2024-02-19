//
//  SizeModifier.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import SwiftUI

struct SizeModifier: ViewModifier {
    @Binding var size: CGSize
    
    init(size: Binding<CGSize>) {
        self._size = size
    }
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            size = proxy.size
                        }
                        .onChange(of: proxy.size, perform: { value in
                            size = proxy.size
                        })
                }
            )
    }
}
