//
//  ListRecipesTableViewController.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 18/10/2021.
//

import UIKit

final class ListRecipesTableViewController: UITableViewController {
    private var recipes: Recipes
    private let stored: Bool ///TRUE If tableView is connected to CoreData(favorite recipes) or FALSE if ApiWeb(search recipes)
    private var hitToPushDetail: Recipes.hits ///The recipe to push in the detail view
    private var positionContainerToPushDetail: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0) ///The container size base to start the animate image in the view
    private var offsetToPushDetail: CGFloat = 0 ///The offset of the image behind the mask view to perfect transition with the detailRecipeView
    private var selectIndexPath: IndexPath = IndexPath()
    private var detailRecipeViewController: DetailRecipeViewController
    private let labelNoRecipe: UILabel = UILabel()
    //private var coredataRecipe: CoredataRecipe?
    //private var isCoredataRecipeActivate: Bool = false
    
    init(stored: Bool) {
        self.stored = stored
        self.recipes = Recipes(from: 0, to: 0, count: 0, _links: Recipes._links(next: Recipes._links.next(href: "")), hits: [])
        self.hitToPushDetail = Recipes.hits.init(recipe: Recipes.hits.recipe(url:"", label: "", image: "", totalTime: 0, yield: 0, ingredientLines: []))
        detailRecipeViewController = DetailRecipeViewController(hit: hitToPushDetail, positionContainer: positionContainerToPushDetail, offset: offsetToPushDetail, stored: stored)
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        self.tableView.backgroundColor = .white
        self.tableView.separatorColor = .clear
        if stored {
            let icon = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
            self.tabBarItem = icon
            self.title = "Favorites"
        } else {
            self.title = "Search"
        }
    }    
    required init?(coder: NSCoder) {
        self.stored = false
        self.recipes = Recipes(from: 0, to: 0, count: 0, _links: Recipes._links(next: Recipes._links.next(href: "")), hits: [])
        self.hitToPushDetail = Recipes.hits.init(recipe: Recipes.hits.recipe(url:"", label: "", image: "", totalTime: 0, yield: 0, ingredientLines: []))
        detailRecipeViewController = DetailRecipeViewController(hit: hitToPushDetail, positionContainer: positionContainerToPushDetail, offset: offsetToPushDetail, stored: stored)
        super.init(nibName: nil, bundle: nil)
        return nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        labelNoRecipe.textColor = .darkGray
        labelNoRecipe.contentMode = .center
        self.tableView.addSubview(labelNoRecipe)
        tableView.register(CellRecipe.self, forCellReuseIdentifier: "cellRecipe")
        detailRecipeViewController.modalPresentationStyle = .overCurrentContext
        addNotifications()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !AppDelegate.coreDataRecipeActivate{
            //isCoredataRecipeActivate = true
            AppDelegate.coreDataRecipeActivate = true
            AppDelegate.coredataRecipe = CoredataRecipe(coreDataStack: AppDelegate.coreDataStack)
        }
        labelNoRecipe.frame = CGRect(x: 4, y: 4, width: self.view.frame.width, height: 40)
        if stored {
            setRecipes(recipes: nil, stored: true)
        }
        setlabelNoRecipe()
    }
// MARK: Notification
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func addNotifications() {
        NotificationCenter.default.addObserver( self, selector: #selector(reloadData),
                                            name: Notification.Name(rawValue: "reloadData"),
                                            object: nil)
    }
    @objc private func reloadData(notification: Notification) {
        if stored {
            setRecipes(recipes: nil, stored: true)
            tableView.reloadData()
        }
        setlabelNoRecipe()
    }
// MARK: Get Set
    func setlabelNoRecipe() {
        if recipes.hits.count == 0 {
            labelNoRecipe.text = "Add your favorites in the Search Tab"
        } else {
            labelNoRecipe.text = ""
        }
    }
    func setRecipes(recipes: Recipes?, stored: Bool) {
        if !stored {
            self.recipes = recipes!
        } else {
            if let recipesStored = AppDelegate.coredataRecipe?.getRecipesStored()  {
                self.recipes = recipesStored
            }
        }
        self.tableView.reloadData()
        setlabelNoRecipe()
    }
// MARK: TableView
    override func  scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in tableView.visibleCells as! [CellRecipe] {
            cell.offsetImage(value: (cell.frame.origin.y-scrollView.contentOffset.y)/12)
        }
    }
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let position: CGRect = tableView.rectForRow(at: selectIndexPath)
        var upPosition: CGFloat = 0
        if stored { upPosition = 20}
        positionContainerToPushDetail = CGRect(x: position.origin.x,
                                               y: position.origin.y-tableView.contentOffset.y-upPosition,
                                               width: position.width,
                                               height: position.height)
        detailRecipeViewController = DetailRecipeViewController(hit: hitToPushDetail,
                                                                positionContainer: positionContainerToPushDetail,
                                                                offset: offsetToPushDetail,
                                                                stored: stored)
        detailRecipeViewController.modalPresentationStyle = .overCurrentContext
        present(detailRecipeViewController, animated: false) { }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = (tableView.cellForRow(at: indexPath) as? CellRecipe) {
            offsetToPushDetail = cell.getOffsetImage()
        }
        var upPosition: CGFloat = 0
        if stored { upPosition = 20}
        let position: CGRect = tableView.rectForRow(at: indexPath)
        positionContainerToPushDetail = CGRect(x: position.origin.x,
                                               y: position.origin.y-tableView.contentOffset.y-upPosition,
                                               width: position.width,
                                               height: position.height)
        hitToPushDetail = recipes.hits[indexPath.row]
        selectIndexPath = indexPath
        
        var scrollStart: Bool = false
        let positionXScroll = tableView.contentOffset.y
        let positionXCell = tableView.rectForRow(at: indexPath).origin.y
        var upWidth: CGFloat = 44
        if stored { upWidth = 20 }
        //Move cell down if cell is truncated at the up of the view
        if positionXCell-upWidth < positionXScroll {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            scrollStart = true
        }
        //Move cell up if cell is truncated at the down of the view
        else if positionXScroll+self.view.frame.size.height-48 < (CGFloat(indexPath.row+1)*CellRecipe.heightRowRecipe) {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            scrollStart = true
        }
        // if the cell is not truncated
        if !scrollStart {
            detailRecipeViewController = DetailRecipeViewController(hit: hitToPushDetail, positionContainer: positionContainerToPushDetail, offset: offsetToPushDetail, stored: stored)
            detailRecipeViewController.modalPresentationStyle = .overCurrentContext
            present(detailRecipeViewController, animated: false) { }
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellRecipe.heightRowRecipe
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.hits.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CellRecipe = CellRecipe(style: .default, reuseIdentifier: "cellRecipe", hit: recipes.hits[indexPath.row])
        cell.offsetImage(value: (CellRecipe.heightRowRecipe*CGFloat(indexPath.row))/12)
        cell.selectionStyle = .none
        return cell
    }
}
