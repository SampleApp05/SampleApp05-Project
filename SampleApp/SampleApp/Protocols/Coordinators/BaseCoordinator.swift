//
//  BaseCoordinator.swift
//  SampleApp
//
//  Created by Daniel Velikov on 2.02.24.
//

import UIKit
import FirebaseAuth

protocol BaseCoordinator: AnyObject {
    var parent: BaseCoordinator? { get }
    var children: [BaseCoordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
    func finish()
    func dismiss(completion: VoidClosure?)
    func popBack()
    func reset()
    func removeFromParent()
    func childDidFinish(_ child: BaseCoordinator)
    func present(_ controller: UIViewController)
}

extension BaseCoordinator {
    func finish() {
        reset()
        removeFromParent()
    }
    
    func popBack() {
        navigationController.popBack()
    }
    
    func dismiss(completion: VoidClosure? = nil) {
        navigationController.dismiss(animated: true, completion: completion)
    }
    
    func reset() {
        children.forEach { $0.reset() }
        children = []
    }
    
    func removeFromParent() {
        parent?.childDidFinish(self)
    }
    
    func childDidFinish(_ child: BaseCoordinator) {
        children.remove(child)
    }
    
    func present(_ controller: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.present(controller, animated: true)
        }
    }
    
    func onMain(deadline: DispatchTime? = nil, _ completion: @escaping VoidClosure) {
        guard let deadline = deadline else {
            DispatchQueue.main.async(execute: completion)
            return
        }
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: completion)
    }
}
