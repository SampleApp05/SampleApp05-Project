//
//  AccountView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 15.02.24.
//

import SwiftUI
import FirebaseAuth

struct AccountView: CoordinatorModelView {
    @ObservedObject private(set) var model: AccountViewModel
    
    init(model: AccountViewModel) {
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 25) {
            VStack(spacing: 40) {
                Text("Account Overview")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(.accent)
                VStack(spacing: 10) {
                    HStack {
                        Text("ID:")
                        Text(model.uuid)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.accent)
                    }
                    
                    HStack {
                        Text("Email:")
                        Text(model.email)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.accent)
                    }
                    
                    HStack {
                        Text("Alias:")
                        Text(model.alias)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.accent)
                    }
                }
            }
            
            Spacer()
            Button {
                model.signOut()
            } label: {
                ZStack {
                    Text("Sign out")
                        .font(.callout)
                        .opacity(model.status == .inProgress ? 0.0 : 1.0)
                    ProgressView()
                        .progressViewStyle(.circular)
                        .opacity(model.status != .inProgress ? 0.0 : 1.0)
                }
                .animation(.easeInOut, value: model.status)
            }
            .font(.system(size: 24))
            .tint(.accentColor)
            .foregroundStyle(.main)
            .buttonStyle(.borderedProminent)
            .disabled(model.status == .inProgress)
            
            if case .error = model.status {
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
                        model.status = .notStarted
                    }
            }
            
            Spacer()
            Spacer()
        }
        .padding(.all, 50)
        .background(Color.main, ignoresSafeAreaEdges: .horizontal)
        .animation(.easeInOut, value: model.status)
    }
}

#Preview {
    AccountView(
        model: .init(
            coordinator: nil,
            injected: .init(
                account: nil,
                authService: Auth.auth(),
                restaurantService: RestaurantService(),
                coreDataService: .init(container: UIApplication.storageContainer!)
            )
        )
    )
}
