//
//  TabViewController.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 11/10/2021.
//

import UIKit
final class TabViewController: UITabBarController {
    var navigationSearchController: NavigationController
    var listRecipeController: ListRecipesTableViewController
    init() {
        navigationSearchController = NavigationController()
        listRecipeController = ListRecipesTableViewController(stored: true)
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .darkGray
        self.setViewControllers([navigationSearchController,listRecipeController], animated: false)
    }
    required init?(coder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        return nil
    }
}
