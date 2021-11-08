//
//  MeteoViewController.swift
//  Baluchon
//
//  Created by Nicolas SERVAIS on 11/10/2021.
//

import UIKit

final class SearchViewController: UIViewController, UITableViewDelegate {
    private var tabHeightDown: CGFloat = 0
    private let heightAddView: CGFloat = 94
    private let sizeButton: CGFloat = 50
    private let spaceOut: CGFloat = 4
    private let navigationWidth: CGFloat = 50
    private var addIngredient: AddIngredientView = AddIngredientView()
    private var listIngredient: ListIngredientView = ListIngredientView()
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Reciplease"
    }
    required init?(coder: NSCoder) {
        return nil
    }
    override func viewDidLoad() {
        self.view.addSubview(addIngredient)
        self.view.addSubview(listIngredient)
        addIngredient.getButtonAdd().addTarget(self, action: #selector(clicAddIngredient(_sender:)), for: .touchUpInside)
        listIngredient.getButtonClear().addTarget(self, action: #selector(clicClear(_sender:)), for: .touchUpInside)
        listIngredient.getButtonSearch().addTarget(self, action: #selector(clicSearch(_sender:)), for: .touchUpInside)
        calculTabHeight()
        redraw()
    }
    override func viewWillLayoutSubviews() {
        addIngredient.redraw(size: CGSize(width: self.view.frame.width-(spaceOut*2),
                                          height: heightAddView))
        listIngredient.redraw(size: CGSize(width: self.view.frame.width-(spaceOut*2),
                                           height: self.view.frame.height-navigationWidth-heightAddView-tabHeightDown-(spaceOut*3)))
    }
    private func redraw() {
        addIngredient.frame = CGRect(x: spaceOut,
                                    y: navigationWidth,
                                    width: self.view.frame.width,
                                    height: heightAddView)
        listIngredient.frame = CGRect(x: spaceOut,
                                      y: navigationWidth+heightAddView+(spaceOut*2),
                                      width: self.view.frame.width-(spaceOut*2),
                                      height: self.view.frame.height-navigationWidth-heightAddView-tabHeightDown-(spaceOut*3))
    }
    private func calculTabHeight() {
        if let tabBarController = tabBarController {
            self.tabHeightDown = tabBarController.tabBar.frame.size.height -
                    tabBarController.tabBar.safeAreaInsets.bottom
            }
    }
// MARK: Action
    @objc private func clicAddIngredient(_sender:UIButton) {
        let ingredientName = addIngredient.getText()
        if ingredientName.isBlank {
            presentAlert(title: "Caution", message: "Whitespace character is not possible")
        } else if ingredientName.isNumeric {
            presentAlert(title: "Caution", message: "Numerical character is not possible")
        } else {
            listIngredient.getListController().addNewIngredient(value: ingredientName)
            addIngredient.resetText()
        }
    }
    @objc private func clicClear(_sender:UIButton) {
        listIngredient.getListController().clearAllIngredients()
    }
    @objc private func clicSearch(_sender:UIButton) {
        NotificationCenter.default.post(name: Notification.Name("setActivityInSearch"), object: true)
        let ingredients: [String] = listIngredient.getListController().getIngredients()
        if ingredients.count > 0 {
            let queryIngredient = ingredients.joined(separator: ",")
            ServiceRecipe.shared.getRecipes(ingredients: queryIngredient) { result in
                NotificationCenter.default.post(name: Notification.Name("setActivityInSearch"), object: false)
                switch result {
                case .success(let listRecip):
                    if listRecip.hits.count > 0 {
                        let listRecipes: ListRecipesTableViewController = ListRecipesTableViewController(stored: false)
                        listRecipes.setRecipes(recipes: listRecip, stored: false)
                        self.navigationController?.pushViewController(listRecipes, animated: true)
                    }
                case .failure(_):
                    self.presentAlert(title: "Message", message: "Bad query")
                }
            }
        } else {
            NotificationCenter.default.post(name: Notification.Name("setActivityInSearch"), object: false)
            presentAlert(title: "Error", message: "Need to one ingredient minimum")
        }
    }
}
