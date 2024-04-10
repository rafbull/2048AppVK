//
//  AppCoordinator.swift
//  2048AppVK
//
//  Created by Rafis on 04.04.2024.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    
    private var childCoordinators = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()
        childCoordinators = [mainCoordinator]
        window.rootViewController = mainCoordinator.rootNavigationController
    }
}
