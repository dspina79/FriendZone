//
//  Coordinator.swift
//  FriendZone2
//
//  Created by Dave Spina on 3/14/21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
}
