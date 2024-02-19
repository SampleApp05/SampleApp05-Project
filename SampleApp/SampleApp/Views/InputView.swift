//
//  InputView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import SwiftUI

struct InputView: View {
    @FocusState private var isFocused
    
    private let placeholder: String
    private let variant: Variant
    @Binding private var input: String
    @State private var placeholderSize: CGSize = .zero
    @State private var isEditing = false
    
    private var shouldShowFullPlaceholder: Bool { isEditing ? false : input.isEmpty }
    
    init(
        _ placeholder: String,
        input: Binding<String>,
        variant: Variant = .plain
    ) {
        self.placeholder = placeholder
        self._input = input
        self.variant = variant
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            Text(placeholder)
                .opacity(0.6)
                .scaleEffect(shouldShowFullPlaceholder ? 1.0 : 0.65, anchor: .leading)
                .alignmentGuide(.top) { (dimensions) in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        shouldShowFullPlaceholder ? dimensions[.top] : dimensions[.top] + (placeholderSize.height)
                    }
                }
                .modifier(SizeModifier(size: $placeholderSize))
                .animation(.easeInOut(duration: 0.25), value: shouldShowFullPlaceholder)
            
            if variant == .secure {
                SecureInputField(text: $input, buttonType: .image)
                .focused($isFocused)
                .keyboardType(variant.keyboardType)
                .animation(.easeInOut(duration: 0.25), value: shouldShowFullPlaceholder)
            } else {
                TextField("", text: $input)
                .focused($isFocused)
                .autocorrectionDisabled(true)
                .keyboardType(variant.keyboardType)
                .autocapitalization(.none)
                .animation(.easeInOut(duration: 0.25), value: shouldShowFullPlaceholder)
            }
        }
        .onChange(of: isFocused) { (value) in
            guard isEditing != value else { return }
            isEditing = value
        }
    }
}

#Preview {
    StatePreviewWrapper(state: ("", false)) { (state) in
        InputView(
            "Placeholder",
            input: state.0,
            variant: .secure
        )
        .padding(20)
        .foregroundColor(.accent)
        .background(.main)
        .font(.system(size: 24))
    }
}
