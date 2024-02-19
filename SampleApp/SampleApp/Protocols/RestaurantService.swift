//
//  RestaurantService.swift
//  SampleApp
//
//  Created by Daniel Velikov on 15.02.24.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

protocol RestaurantDataService {
    func fetchRestaurants() async throws -> [Restaurant]
    func fetchPhoto(path: String) async throws -> UIImage?
    func storeRestaurants(_ data: [Restaurant]) async throws
    
    @discardableResult
    func storeRestaurantPhoto(image: UIImage, name: String) async throws -> String?
}

class RestaurantService: RestaurantDataService {
    private let storage = Storage.storage()
    var storageRef: StorageReference { storage.reference() }
    var restaurantsReference: DatabaseReference { Database.database().reference().child("restaurants") }
    
    func fetchRestaurants() async throws -> [Restaurant] {
        try await restaurantsReference.getData().data(as: [Restaurant].self).sorted(by: { $0.rating > $1.rating })
    }
    
    @discardableResult
    func storeRestaurantPhoto(image: UIImage, name: String) async throws -> String? {
        guard let data = image.jpegData(compressionQuality: 0.2) else { return nil }
        let imageRef = storageRef.child("images/\(name)")
        let _ = try await imageRef.putDataAsync(data)
        
        return try await imageRef.downloadURL().absoluteString
    }
    
    func fetchPhoto(path: String) async throws -> UIImage? {
        let imageRef = storageRef.child("images/\(path)")
        
        let data: Data = try await withCheckedThrowingContinuation { (continuation) in
            imageRef.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("Error Fetching image: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let data = data else {
                    continuation.resume(throwing: RequestError.missingData)
                    return
                }
                
                continuation.resume(returning: data)
            }
        }
        
        return .init(data: data)
    }
    
    func storeRestaurants(_ data: [Restaurant]) async throws {
        let _ = try await restaurantsReference.setValue(data.map { $0.asJson })
    }
}
