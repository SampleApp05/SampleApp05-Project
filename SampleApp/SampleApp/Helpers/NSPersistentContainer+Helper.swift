//
//  NSPersistentContainer+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 19.02.24.
//

import CoreData

extension NSPersistentContainer {
    func saveContext() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            print("Error saving CoreData context: \(error)")
        }
    }
}
