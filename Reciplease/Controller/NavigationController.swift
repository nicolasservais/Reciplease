//
//  NavigationController.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 11/10/2021.
//

import Foundation
import UIKit

final class NavigationController: UINavigationController {
    private let heightBoxView: CGFloat = 140
    private let sizeButton: CGFloat = 50
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.isOpaque = false
        self.view.backgroundColor = .clear
        self.navigationBar.backgroundColor = .darkGray
        self.navigationBar.barStyle = .black
        self.navigationBar.isTranslucent = true
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    required init?(coder: NSCoder) {
        return nil
        //fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
            let icon = UITabBarItem(tabBarSystemItem: .search, tag: 0)
            self.tabBarItem = icon
            let searchViewController = SearchViewController()
            self.pushViewController(searchViewController, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.constraintToSafeArea()
        
    }
}
