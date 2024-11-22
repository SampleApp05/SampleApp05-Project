//
//  SplashView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import SwiftUI
import FirebaseAuth

struct SplashView: CoordinatorModelView {
    @State private var hasAppeared = false
    
    @ObservedObject private(set) var model: SplashViewModel
    
    init(model: SplashViewModel) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("SampleApp")
                .foregroundStyle(.main)
                .font(.system(size: 52, weight: .semibold))
                .scaleEffect(hasAppeared ? 1 : 3)
                .blur(radius: hasAppeared ? 0 : 3)
                .animation(
                    .easeInOut(duration: 0.65),
                    value: hasAppeared
                )
            Spacer()
            
            if model.splashVariant == .initial {
                VStack(alignment: .center, spacing: 20) {
                    Button("Sign in") {
                        model.coordinator?.navigate(to: .login)
                    }
                    .tint(.main)
                    .buttonStyle(.borderedProminent)
                    
                    Button("Sign Up") {
                        model.coordinator?.navigate(to: .register)
                    }
                    .tint(.main)
                    .buttonStyle(.borderedProminent)
                }
                .padding(.bottom, 100)
                .foregroundStyle(.accent)
                .opacity(hasAppeared ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.25).delay(0.75), value: hasAppeared)
            }
        }
        .frame(maxWidth: .infinity)
        .background(.accent)
        .onAppear {
            hasAppeared = true
            model.navigateToNextScreen()
        }
    }
}

#Preview {
    SplashView(model: .init(service: Auth.auth(), accountStatus: .noData, email: nil))
}
