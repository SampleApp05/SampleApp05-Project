//
//  SecureInputView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import SwiftUI

struct SecureInputField: View {
    enum ButtonType {
        case text
        case image
    }
    
    @Environment(\.isEnabled) private var isEnabled
    
    private let placeholder: String
    private let buttonType: ButtonType
    @Binding private var text: String
    @State private var showsSecureField: Bool = true
    @State private var showsPlainField: Bool = false
    
    private var shouldShowSecureField: Bool { isEnabled ? showsSecureField : true}
    
    private var shouldShowPlainField: Bool { isEnabled ? showsPlainField : false }
    
    init(
        _ placeholder: String = "",
        text: Binding<String>,
        buttonType: ButtonType = .image
    ) {
        self.placeholder = placeholder
        self._text = text
        self.buttonType = buttonType
    }
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack(alignment: .leading) {
                TextField(placeholder, text: $text)
                .transition(.opacity)
                .opacity(shouldShowPlainField ? 1.0 : 0.0)
                .autocorrectionDisabled(true)
                .animation(
                    .easeInOut(duration: 0.25).delay(shouldShowPlainField ? 0.1 : 0.0),
                    value: shouldShowPlainField
                )
                
                SecureField(placeholder, text: $text)
                .transition(.opacity)
                .opacity(shouldShowSecureField ? 1.0 : 0.0)
                .animation(
                    .easeInOut(duration: 0.25).delay(shouldShowSecureField ? 0.1 : 0.0),
                    value: shouldShowSecureField
                )
            }
            Button {
                showsPlainField.toggle()
                showsSecureField.toggle()
            } label: {
                if text.isEmpty == false {
                    switch buttonType {
                    case .text:
                        Text(shouldShowSecureField ? "Show" : "Hide")
                    case .image:
                        Image(systemName: shouldShowSecureField ? "eye" : "eye.slash")
                    }
                }
            }
        }
    }
}

#Preview {
    StatePreviewWrapper(state: "123") {
        SecureInputField(text: $0)
        .font(.system(size: 24))
        .foregroundColor(.black)
        .background(Color.gray)
    }
}
