//
//  MainCoordinator.swift
//  FriendZone2
//
//  Created by Dave Spina on 3/14/21.
//


import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ViewController.instantiate()
        navigationController.pushViewController(vc, animated: false)
    }
}
