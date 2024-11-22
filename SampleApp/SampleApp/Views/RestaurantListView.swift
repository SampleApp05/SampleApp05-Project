//
//  RestaurantListView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 22.11.24.
//

import SwiftUI

struct RestaurantListView: CoordinatorModelView {
    @Bindable var model: RestaurantsViewModel
    
    init(model: RestaurantsViewModel) {
        self.model = model
    }
    
    @ViewBuilder private var loadingView: some View {
        VStack {
            Spacer()
            
            Text("Sit tight, we are loading the restaurants")
                .foregroundStyle(.accent)
                .font(.largeTitle)
            ProgressView()
                .controlSize(.extraLarge)
                .tint(.accent)
            
            Spacer()
        }
        .padding(50)
    }
    
    @ViewBuilder private var restaurantsView: some View {
        List(model.restaurants) { (restaurant) in
            RestaurantView(
                name: restaurant.name,
                rating: restaurant.displayRating
            ) {
                await model.imageURL(for: restaurant.url)
            } tapAction: {
                model.showRestaurantFeedback(for: restaurant)
            }
            .listRowSeparator(.hidden)
            .onTapGesture {
                model.showRestaurantDetails(for: restaurant)
            }
            .swipeActions {
                ForEach(model.swipeActions, id: \.rawValue) { (action) in
                    swipeActionView(for: action, restaurant: restaurant)
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
    
    @ViewBuilder
    private func swipeActionView(
        for variant: UIContextualAction.Variant,
        restaurant: Restaurant
    ) -> some View {
        Button {
            model.swipeAction(for: variant, restaurant: restaurant)
        } label: {
            Text(variant.rawValue.uppercased())
                .foregroundStyle(.white)
        }
        .tint(Color(uiColor: variant.background))
    }
    
    @ViewBuilder private var contentView: some View {
        if model.shouldShowLoadingView {
            loadingView
        } else {
            restaurantsView
                .navigationTitle("Restaurants List")
                .refreshable {
                    await model.fetchRestaurants()
                }
        }
    }
    
    var body: some View {
        contentView
            .task {
                await model.fetchRestaurants()
            }
    }
}

#Preview {
    RestaurantListView(model: .init(injeted: .mock))
}
