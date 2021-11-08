//
//  ListIngredient.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 12/10/2021.
//

import UIKit

class ListIngredientView: UIView {
    
    private let widthButtonClear: CGFloat = 80
    private let heightButton: CGFloat = 40
    private let spaceIn: CGFloat = 8
    private let label: UILabel = UILabel()
    private let listIngredient: ListTableViewController = ListTableViewController()
    private let buttonClear: UIButton = UIButton()
    private let buttonSearch: UIButton = UIButton()
    private let activityLoad: UIActivityIndicatorView = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 12
        label.text = "My ingredients"
        label.textColor = .darkGray
        label.textAlignment = .center
        listIngredient.view.layer.cornerRadius = 8
        listIngredient.view.layer.borderWidth = 2
        listIngredient.view.layer.borderColor = UIColor.darkGray.cgColor
        buttonClear.layer.cornerRadius = 8
        buttonClear.layer.backgroundColor = UIColor.systemRed.cgColor
        buttonClear.setTitle("Clear", for: .normal)
        buttonClear.accessibilityIdentifier = "clear"
        buttonSearch.layer.cornerRadius = 8
        buttonSearch.layer.backgroundColor = UIColor.systemGreen.cgColor
        buttonSearch.setTitle("Search for recipes", for: .normal)
        buttonSearch.accessibilityIdentifier = "search"
        activityLoad.style = .medium
        buttonSearch.addSubview(activityLoad)
        self.addSubview(label)
        self.addSubview(listIngredient.view)
        self.addSubview(buttonClear)
        self.addSubview(buttonSearch)
        self.backgroundColor = .white
        NotificationCenter.default.addObserver( self, selector: #selector(setActivity(notification:)),
                                                name: Notification.Name(rawValue: "setActivityInSearch"),
                                                object: nil)
    }
    required init?(coder: NSCoder) {
        return nil
    }
// MARK: Notification
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc private func setActivity(notification: Notification) {
        if let value: Bool = notification.object as? Bool {
            if value {
                activityLoad.startAnimating()
            } else {
                activityLoad.stopAnimating()
            }
        }
    }
    func redraw(size: CGSize) {
        self.frame = CGRect(x: self.frame.origin.x,
                            y: self.frame.origin.y,
                            width: size.width,
                            height: size.height)
        label.frame = CGRect(x: spaceIn,
                             y: spaceIn,
                             width: size.width-spaceIn,
                             height: heightButton)
        listIngredient.view.frame = CGRect(x: spaceIn,
                                           y: heightButton+(spaceIn*2),
                                           width: size.width-(spaceIn*2),
                                           height: size.height-(heightButton*2)-(spaceIn*4))
        buttonClear.frame = CGRect(x: size.width-widthButtonClear,
                                   y: size.height-heightButton-spaceIn ,
                                   width: widthButtonClear-spaceIn,
                                   height: heightButton)
        buttonSearch.frame = CGRect(x: spaceIn,
                                    y: size.height-heightButton-spaceIn,
                                    width: size.width-(spaceIn*2)-widthButtonClear,
                                    height: heightButton)
        activityLoad.frame = CGRect(x: buttonSearch.frame.width-heightButton,
                                    y: 4,
                                    width: heightButton-8,
                                    height: heightButton-8)
    }
    func getButtonClear() -> UIButton {
        return buttonClear
    }
    func getButtonSearch() -> UIButton {
        return buttonSearch
    }
    func getListController() -> ListTableViewController {
        return listIngredient
    }
}
