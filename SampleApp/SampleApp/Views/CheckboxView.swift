//
//  CheckboxView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 13.02.24.
//

import SwiftUI

struct CheckboxView: View {
    private let text: String
    @Binding private var enabled: Bool
    
    init(text: String, enabled: Binding<Bool>) {
        self.text = text
        self._enabled = enabled
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image(systemName: enabled ? "checkmark.circle.fill" : "checkmark.circle")
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundStyle(enabled ? .accent : .main)
            Text(text)
                .font(.system(size: 18))
            Spacer()
        }
        .animation(.easeInOut, value: enabled)
        //.padding(.all, 50)
        //.background(.red)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onTapGesture {
            enabled.toggle()
        }
    }
}

#Preview {
    StatePreviewWrapper(state: false) { (state) in
        CheckboxView(text: "Checkbox", enabled: state)
    }
}
