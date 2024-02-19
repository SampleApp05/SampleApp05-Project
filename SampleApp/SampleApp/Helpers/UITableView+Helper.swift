//
//  UITableView+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 5.02.24.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func registerCelNib<T: UITableViewCell>(_ type: T.Type) {
        register(.init(nibName: T.identifier, bundle: .main), forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(_ type: T.Type, for index: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: T.identifier, for: index) as? T
    }
}
