//
//  NavigationController.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 11/10/2021.
//

import Foundation
import UIKit

final class NavigationSearchController: UINavigationController {
    private let heightBoxView: CGFloat = 140
    private let sizeButton: CGFloat = 50
    let searchViewController = SearchViewController()
    init() {
        super.init(nibName: nil, bundle: nil)
        let icon = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        self.tabBarItem = icon
        self.view.backgroundColor = .darkGray
        self.navigationBar.backgroundColor = .darkGray
        //self.view.layer.cornerRadius = 12
        //self.view.layer.borderColor = UIColor.red.cgColor
        //self.view.layer.borderWidth = 2
        //self.view.constraintToSuperView()
        //let label = UILabel()
        //label.textColor = .blue
        //label.text = "Reciplease"
        //self.navigationItem.titleView = label
        //searchViewController.view.constraintToSafeArea()

        self.navigationBar.barStyle = .black
        self.navigationBar.isTranslucent = true
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        //self.navigationBar.setNeedsLayout()
        self.pushViewController(searchViewController, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.constraintToSafeArea()
        
    }
    //override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //print("viewWillTransition")
        //searchViewController.redraw(size: size)
    //}

}
