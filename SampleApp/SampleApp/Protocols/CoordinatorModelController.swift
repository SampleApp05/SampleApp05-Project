//
//  CoordinatorModelController.swift
//  SampleApp
//
//  Created by Daniel Velikov on 15.02.24.
//

import UIKit

protocol CoordinatorModelController: UIViewController {
    associatedtype T: CoordinatorModel
    
    var model: T { get }
}
