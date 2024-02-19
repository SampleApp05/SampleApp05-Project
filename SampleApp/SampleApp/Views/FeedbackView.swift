//
//  FeedbackView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 16.02.24.
//

import SwiftUI

struct FeedbackView: CoordinatorModelView {
    private struct Constants {
        static let defaultEmoji = "🧐"
        static let starImage = "star"
        static let starFillImage = "star.fill"
    }
    
    @FocusState private var hasInputFocus: Bool
    @ObservedObject private(set) var model: FeedbackViewModel
    
    init(model: FeedbackViewModel) {
        self.model = model
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 50) {
                VStack(spacing: 8) {
                    Text("\(model.variant.restaurant.name)")
                        .font(.system(size: 36, weight: .regular))
                        .foregroundStyle(.main)
                    Text("How was your experiance")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.white)
                }
                VStack(spacing: 20) {
                    Text(model.displayRating?.emoji ?? Constants.defaultEmoji)
                        .font(.title)
                        .foregroundStyle(.main)
                    
                    HStack {
                        ForEach(FeedbackRating.allCases, id: \.self) { (value) in
                            let image: String = {
                                guard Double(value.rawValue) <= model.rating else { return Constants.starImage }
                                
                                return Constants.starFillImage
                            }()
                            
                            Image(systemName: image)
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.main)
                                .simultaneousGesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            model.rating = Double(value.rawValue)
                                        }
                                )
                        }
                    }
                    
                    Slider(value: $model.rating, in: 1...5, step: 0.1)
                        .frame(maxWidth: 250)
                        .padding(.all, 10)
                        .background(.main)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                VStack(spacing: 25) {
                    Text("Would you like to tell us more?")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(.white)
                    
                    VStack(spacing: 8) {
                        TextEditor(text: $model.comment)
                            .focused($hasInputFocus)
                            .frame(height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(.accent)
                            .autocorrectionDisabled(true)
                            .keyboardType(.alphabet)
                        HStack(spacing: 5) {
                            Spacer()
                            Text("Characters:")
                                .foregroundStyle(.main)
                            Text("\(model.remainingCharecters)")
                                .foregroundStyle(model.remainingCharecters < 25 ? .red : .main)
                        }
                        .font(.caption)
                    }
                    
                    Button {
                        model.submitReviewIfPossible()
                    } label: {
                        ZStack {
                            Text("Submit")
                                .font(.system(size: 24))
                                .opacity(model.requestStatus == .inProgress ? 0.0 : 1.0)
                            ProgressView()
                                .progressViewStyle(.circular)
                                .opacity(model.requestStatus != .inProgress ? 0.0 : 1.0)
                                .tint(.accent)
                        }
                        .animation(.easeInOut, value: model.requestStatus)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.main)
                    .foregroundStyle(.accent)
                    .disabled(model.rating < 1)
                }
                Spacer()
            }
            .padding(.all, 50)
        }
        .background(Color.accentColor, ignoresSafeAreaEdges: model.variant.ignoreEdgeInsets)
        .animation(.easeInOut, value: model.rating)
        .onChange(of: model.rating) { (_) in
            model.displayRating = .init(rawValue: Int(model.rating))
        }
        .onChange(of: model.comment) { (_) in
            guard model.remainingCharecters <= 0 else { return }
            model.comment = String(model.comment.prefix(model.characterLimit))
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    hasInputFocus = false
                }
        )
    }
}

#Preview {
    FeedbackView(
        model: .init(
            coordinator: nil,
            variant: .add(
                restaurant: .init(
                    id: "1",
                    name: "Test Restaurant",
                    url: "",
                    rating: 5
                )
            ),
            service: CoreDataService(container: UIApplication.storageContainer!)
        )
    )
}

