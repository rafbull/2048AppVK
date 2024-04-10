//
//  MainCoordinator.swift
//  2048AppVK
//
//  Created by Rafis on 04.04.2024.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var rootNavigationController: UINavigationController
    
    private var mainViewModel: MainViewModelProtocol
    
    
    init(
        navigationController: UINavigationController = MainNavigationController(),
        mainViewModel: MainViewModelProtocol = MainViewModel()
    ) {
        self.rootNavigationController = navigationController
        self.mainViewModel = mainViewModel
    }
    
    func start() {
        let mainViewController = MainViewController(viewModel: mainViewModel)
        rootNavigationController.setViewControllers([mainViewController], animated: true)
    }
}
