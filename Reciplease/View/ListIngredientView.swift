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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 12
        label.text = "My ingredients"
        label.textAlignment = .center
        listIngredient.view.layer.cornerRadius = 8
        listIngredient.view.layer.borderWidth = 2
        listIngredient.view.layer.borderColor = UIColor.darkGray.cgColor
        buttonClear.layer.cornerRadius = 8
        buttonClear.layer.backgroundColor = UIColor.systemRed.cgColor
        buttonClear.setTitle("Clear", for: .normal)
        buttonSearch.layer.cornerRadius = 8
        buttonSearch.layer.backgroundColor = UIColor.systemGreen.cgColor
        buttonSearch.setTitle("Search for recipes", for: .normal)
        self.addSubview(label)
        self.addSubview(listIngredient.view)
        self.addSubview(buttonClear)
        self.addSubview(buttonSearch)

        self.backgroundColor = .white
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func redraw(size: CGSize) {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: size.width, height: size.height)
        label.frame = CGRect(x: spaceIn, y: spaceIn, width: size.width-spaceIn, height: heightButton)
        listIngredient.view.frame = CGRect(x: spaceIn, y: heightButton+(spaceIn*2), width: size.width-(spaceIn*2), height: size.height-(heightButton*2)-(spaceIn*4))
        buttonClear.frame = CGRect(x: size.width-widthButtonClear, y: size.height-heightButton-spaceIn , width: widthButtonClear-spaceIn, height: heightButton)
        buttonSearch.frame = CGRect(x: spaceIn, y: size.height-heightButton-spaceIn, width: size.width-(spaceIn*2)-widthButtonClear, height: heightButton)
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
