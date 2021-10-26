//
//  TabViewController.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 11/10/2021.
//

import UIKit

struct Space {
    let min: CGFloat = 12
    let max: CGFloat = 30
    var up: CGFloat = 12
    var down: CGFloat = 12
    var left: CGFloat = 12
    var right: CGFloat = 12
}

final class TabViewController: UITabBarController {

    var navigationSearchController: NavigationSearchController
    var favoriteViewController: FavoriteViewController
    var space: Space
    init() {
        space = Space()
        navigationSearchController = NavigationSearchController()
        favoriteViewController = FavoriteViewController()
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .darkGray
        self.setViewControllers([navigationSearchController,favoriteViewController], animated: false)
        //navigationSearchController.view.constraintToSafeArea()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UIView {

/*    ///Constraints a view to its superview
    func constraintToSuperView() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false

        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
    }
*/
    ///Constraints a view to its superview safe area
    func constraintToSafeArea() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false

        topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor).isActive = true
    }

}
