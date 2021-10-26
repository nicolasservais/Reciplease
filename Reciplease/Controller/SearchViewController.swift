//
//  MeteoViewController.swift
//  Baluchon
//
//  Created by Nicolas SERVAIS on 11/10/2021.
//

import UIKit

final class SearchViewController: UIViewController, UITableViewDelegate {
    private let heightAddView: CGFloat = 94
    private let sizeButton: CGFloat = 50
    private let spaceOut: CGFloat = 4
    private let navigationWidth: CGFloat = 50
    private let tabWidth: CGFloat = 50
    private var addIngredient: AddIngredientView = AddIngredientView()
    private var listIngredient: ListIngredientView = ListIngredientView()
    private let serviceRecipes: ServiceRecipes
    //private var listController: ListTableViewController = ListTableViewController()
    init() {
        serviceRecipes = ServiceRecipes.shared
        super.init(nibName: nil, bundle: nil)
        self.title = "Reciplease"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        addIngredient = AddIngredientView(frame: CGRect(x: spaceOut, y: navigationWidth, width: self.view.frame.width, height: heightAddView))
        listIngredient = ListIngredientView(frame: CGRect(x: spaceOut, y: navigationWidth+heightAddView+(spaceOut*2), width: self.view.frame.width-(spaceOut*2), height: self.view.frame.height-navigationWidth-heightAddView-tabWidth-(spaceOut*3)))
        self.view.addSubview(addIngredient)
        self.view.addSubview(listIngredient)
        addIngredient.getButtonAdd().addTarget(self, action: #selector(clicAddIngredient(_sender:)), for: .touchUpInside)
        listIngredient.getButtonClear().addTarget(self, action: #selector(clicClear(_sender:)), for: .touchUpInside)
        listIngredient.getButtonSearch().addTarget(self, action: #selector(clicSearch(_sender:)), for: .touchUpInside)
        
        //let listIngredientController = ListTableViewController()
        //listIngredient.getListIngredient().delegate = listIngredientController
        //self.view.layer.cornerRadius = 12
        //self.view.layer.borderColor = UIColor.blue.cgColor
        //self.view.layer.borderWidth = 4
    }
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        //listIngredient.getListIngredient().reloadData()
    }
    override func viewWillLayoutSubviews() {
        addIngredient.redraw(size: CGSize(width: self.view.frame.width-(spaceOut*2), height: heightAddView))
        listIngredient.redraw(size: CGSize(width: self.view.frame.width-(spaceOut*2), height: self.view.frame.height-navigationWidth-heightAddView-tabWidth-(spaceOut*3)))
    }
    @objc func clicAddIngredient(_sender:UIButton) {
        listIngredient.getListController().addNewIngredient(value: addIngredient.getText())
        addIngredient.resetText()
    }
    @objc func clicClear(_sender:UIButton) {
        listIngredient.getListController().clearAllIngredients()
    }
    @objc func clicSearch(_sender:UIButton) {
        /*let ingredients: [String] = listIngredient.getListController().getIngredients()
        if ingredients.count > 0 {
            var queryIngredient: String = ""
            for ingredient in ingredients {
                queryIngredient.append(contentsOf: ingredient)
                queryIngredient.append(contentsOf: " ")
            }
            print("query: \(queryIngredient)")
            serviceRecipes.getRecipes(query: queryIngredient) { success, recipes in
                if success{
                    for recette in recipes!.hits {
                        print("recette: \(recette.recipe.label)")
                    }
                    if let listRecip = recipes {
                        if listRecip.hits.count > 0 {
                            let listRecipes: ListRecipesTableViewController = ListRecipesTableViewController(recipes: listRecip)
                            self.navigationController?.pushViewController(listRecipes, animated: true)
                        }
                    } else {
                        self.presentAlert(message: "Bad query")
                    }
                } else {
                    print("Not success")
                }
            }
        } else {
            presentAlert(message: "Need to one ingredient minimum")
        }*/
        /*
        serviceRecipes.getRecipes(query: "chicken") { success, recipes in
            if success{
                for recette in recipes!.hits {
                    print("recette: \(recette.recipe.label)")
                }
                /*let str = String("from: \(recipes?.from) to: \(recipes?.to) count: \(recipes?.count) href: \(recipes?._links.next.href) hit: \(recipes?.hits)")
                print(str)
                */
                //print(recipes?.)
                /*if let recip = recipes {
                    for hit in recip.hits {
                        print("hits: \(hit.label)")
                    }
                }*/

            } else {
                print("Not success")
            }
        }
         */
        
        if let data = readDataRepresentationFromFile(resource: "RecipesRessource", type: "json") {
            //let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            //print("reccipes data Change: \(string1)")
           
            do {
                let jsonDecoder = JSONDecoder()
                let parsedJSON = try jsonDecoder.decode(Recipes.self, from: data)
            
                //if let listRecip = recipes {
                if parsedJSON.hits.count > 0 {
                        let listRecipes: ListRecipesTableViewController = ListRecipesTableViewController(recipes: parsedJSON, stored: false)
                        self.navigationController?.pushViewController(listRecipes, animated: true)
                    }
                //} else {
                //    self.presentAlert(message: "Bad query")
                //}
                //let links = parsedJSON.links
                //let str = String("from: \(parsedJSON.from) to: \(parsedJSON.to) count: \(parsedJSON.count) href: \(parsedJSON._links.next.href)")
                //print(str)
                
                } catch {
                    print("CATCH ERROR JSON")
                }
        } else {
            print("ERROR JSON")
        }
    }
    private func presentAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    public func readDataRepresentationFromFile(resource: String, type: String) -> Data? {
        let filePath = Bundle.main.path(forResource: resource, ofType: type)
        
        if let path = filePath {
            let result = FileManager.default.contents(atPath: path)
            return result
        }
        return nil
    }
}
