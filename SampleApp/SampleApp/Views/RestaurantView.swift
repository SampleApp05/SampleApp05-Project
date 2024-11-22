//
//  RestaurantView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 22.11.24.
//

import SwiftUI

struct RestaurantView: View {
    @State private var size: CGSize = .zero
    @State private var url: URL? = nil
    
    private let name: String
    private let rating: String
    private let imageURL: () async -> URL?
    private let tapAction: VoidClosure
    
    init(
        name: String,
        rating: String,
        imageURL: @escaping () async -> URL?,
        tapAction: @escaping VoidClosure
    ) {
        self.name = name
        self.rating = rating
        self.imageURL = imageURL
        self.tapAction = tapAction
    }
    
    var body: some View {
        VStack(spacing: 5) {
            AsyncImage(url: url) { (image) in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: 250)
                    .clipShape(.rect(cornerRadius: 15))
            } placeholder: {
                ProgressView()
                    .tint(.main)
            }
            .frame(width: size.width, height: 250)
            
            VStack {
                HStack {
                    Text(name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    HStack(alignment: .bottom, spacing: 5) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(rating)
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
                }
                .padding(.horizontal, 25)
                .foregroundStyle(.main)
                
                Button {
                    tapAction()
                } label: {
                    Text("Rate us now!")
                        .font(.title2)
                }
                .buttonStyle(.bordered)
                .tint(.main)
            }
            .padding(15)
        }
        .background(.accent.opacity(0.75))
        .clipShape(.rect(cornerRadius: 35))
        .modifier(SizeModifier(size: $size))
        .task {
            url = await imageURL()
        }
    }
}

#Preview {
    RestaurantView(
        name: "Test Restaurant",
        rating: "3.5"
    ) {
        .init(string: "https://picsum.photos/id/237/400/400")
    } tapAction: {
        print("Button Tapped")
    }
}
