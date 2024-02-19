//
//  UIApplication+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 16.02.24.
//

import UIKit
import CoreData

extension UIApplication {
    static var storageContainer: NSPersistentContainer? { (shared.delegate as? AppDelegate)?.persistentContainer }
    
    static var openSettingsAction: VoidClosure? {
        guard let url = URL(string: UIApplication.openSettingsURLString), shared.canOpenURL(url) else {
            return nil
        }
        
        return { shared.open(url) }
    }
}
