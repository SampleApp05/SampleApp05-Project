//
//  EditRestaurantView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 21.11.24.
//

import SwiftUI
import PhotosUI

struct EditRestaurantView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                Text("Select a photo")
            }
            .onChange(of: selectedItem) {
                Task {
                    // Retrieve selected asset in the form of Data
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
        
        if let selectedImageData,
           let uiImage = UIImage(data: selectedImageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
        }
    }
}

#Preview {
    EditRestaurantView()
}
