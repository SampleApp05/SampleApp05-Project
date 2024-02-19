//
//  RegisterView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import SwiftUI
import FirebaseAuth

enum RequestStatus {
    case notStarted
    case inProgress
    case success
    case error
}

class LoginViewModel<Service: SignInService>: ObservableObject, SignInViewModel {
    weak var coordinator: AppCoordinator?
    let service: Service
    
    @Published var hasValidEmail = false
    @Published var hasValidPassword = false
    @Published var requestStatus: RequestStatus = .notStarted
    @Published var email: String = ""
    @Published var password: String = ""
    
    init(coordinator: AppCoordinator?, service: Service) {
        self.coordinator = coordinator
        self.service = service
    }
}

struct SignInView<T: AuthViewModel>: CoordinatorModelView {
    enum FocusField {
        case email
        case password
    }
    
    @FocusState private var focusField: FocusField?
    @ObservedObject var model: T
    
    init(model: T) {
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 125) {
            Text("Welcome!")
                .padding(.top, 32)
                .font(.system(size: 36, weight: .semibold))
            VStack(alignment: .leading, spacing: 25) {
                InputView(
                    "Email",
                    input: $model.email
                )
                .focused($focusField, equals: .email)
                .font(.system(size: 22, weight: .medium))
                .modifier(DividerModifier(color: model.hasValidEmail ? .accentColor : .main))
                .animation(.easeInOut(duration: 0.25), value: model.hasValidEmail)
                
                InputView(
                    "Password",
                    input: $model.password,
                    variant: .secure
                )
                .focused($focusField, equals: .email)
                .font(.system(size: 22, weight: .medium))
                .modifier(DividerModifier(color: model.hasValidPassword ? .accentColor : .main))
                .animation(.easeInOut(duration: 0.25), value: model.hasValidPassword)
                
                if case .error = model.requestStatus {
                    Text("Something went wrong. Please try again!")
                        .foregroundStyle(.main)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.init(vertical: 12, horizontal: 25))
                        .transition(.asymmetric(insertion: .opacity, removal: .identity))
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .onTapGesture {
                            model.requestStatus = .notStarted
                        }
                }
            }
            Button("Continue") {
                focusField = nil
                if model.requestStatus != .error {
                    model.requestStatus = .error
                } else {
                    model.requestStatus = .notStarted
                }
            }
            .font(.system(size: 24))
            .tint(.main)
            .foregroundStyle(.accent)
            .buttonStyle(.borderedProminent)
            .disabled(model.hasValidEmail == false || model.hasValidPassword == false)
            Spacer()
        }
        .padding(.init(vertical: 50, horizontal: 40))
        .animation(.easeInOut, value: focusField)
        .animation(.easeInOut, value: model.requestStatus == .error)
        .contentShape(.rect)
        .onChange(of: focusField) { (value) in
            guard model.requestStatus == .error, value != nil else { return }
            model.requestStatus = .notStarted
        }
        .onChange(of: model.email) { (_) in
            model.validate(.email)
        }
        .onChange(of: model.password) { (_) in
            model.validate(.password)
        }
    }
}

#Preview {
    SignInView(model: LoginViewModel(coordinator: nil, service: Auth.auth()))
}
