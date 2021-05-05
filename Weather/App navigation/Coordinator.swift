//
//  Coordinator.swift
//  Weather
//
//  Created by Егор Никитин on 05.05.2021.
//

import UIKit

protocol Coordinator: class {
    
    var navigator : UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func childDidFinish(_ child: Coordinator?)
}
