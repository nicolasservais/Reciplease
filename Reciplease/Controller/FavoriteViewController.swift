//
//  MeteoViewController.swift
//  Baluchon
//
//  Created by Nicolas SERVAIS on 11/10/2021.
//

import UIKit

final class FavoriteViewController: UIViewController {
    private let heightBoxView: CGFloat = 140
    private let sizeButton: CGFloat = 50
    init() {
        super.init(nibName: nil, bundle: nil)
        let icon = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        self.tabBarItem = icon
        self.view.backgroundColor = .white
        self.view.constraintToSafeArea()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    }
    override func viewDidLayoutSubviews() {
    }
        
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The data download failed.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
