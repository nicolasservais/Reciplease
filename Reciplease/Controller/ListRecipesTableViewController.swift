//
//  ListRecipesTableViewController.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 18/10/2021.
//

import Foundation
import UIKit

final class ListRecipesTableViewController: UITableViewController {
    let recipes: Recipes
    let stored: Bool ///TRUE If tableView is connected to CoreData(favorite recipes) or FALSE if ApiWeb(search recipes)
    var hitToPushDetail: Recipes.hits
    var positionImageToPushDetail: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var selectIndexPath: IndexPath = IndexPath()
    init(recipes: Recipes, stored: Bool) {
        self.stored = stored
        self.recipes = recipes
        self.hitToPushDetail = recipes.hits[0]
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .darkGray
        self.tableView.separatorColor = .clear
        self.title = "Search"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tableView.register(CellRecipe.self, forCellReuseIdentifier: "cellRecipe")
    }
    
    override func  scrollViewDidScroll(_ scrollView: UIScrollView) {

        
        let visibleCells = self.tableView.visibleCells

        /*for cell in visibleCells {
            if let myCell = cell as! CellRecipe {
                
            }
            //cell.cellOnTableView(tableView: self.tableView, view: self.view, offset: (cell.frame.origin.y)-scrollView.contentOffset.y)
        }
        */
        for cell in tableView.visibleCells as! [CellRecipe] {
            cell.cellOnTableView(tableView: self.tableView, view: self.view, offset: (cell.frame.origin.y)-scrollView.contentOffset.y)

        }
        
        //[cell cellOnTableView:self.tableView didScrollOnView:self.view withOffset:(cell.frame.origin.y - scrollView.contentOffset.y)];
    //}
        /*if let visibleCells: [CellRecipe] = self.tableView.visibleCells as [CellRecipe]? {
            for cell in visibleCells {
            }
        }*/

        //for cell in tableView.visibleCells {
            
        //}
        
        
            //if let myCell: CellRecipe = cell as! CellRecipe {
                
            //}
        //let cell = visibleCells[0]

        //[cell cellOnTableView:self.tableView didScrollOnView:self.view withOffset:(cell.frame.origin.y - scrollView.contentOffset.y)];
    }
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let position: CGRect = tableView.rectForRow(at: selectIndexPath)
        positionImageToPushDetail = CGRect(x: position.origin.x, y: position.origin.y-tableView.contentOffset.y, width: position.width, height: position.height)

        let detailRecipeView: DetailRecipeView = DetailRecipeView(hit: hitToPushDetail, positionImage: positionImageToPushDetail)
        detailRecipeView.modalPresentationStyle = .overCurrentContext
        present(detailRecipeView, animated: false) { }

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        //tableView.cellForRow(at: indexPath).selectCe
        //if
        //tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
        //tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        selectIndexPath = indexPath
        let position: CGRect = tableView.rectForRow(at: indexPath)
        positionImageToPushDetail = CGRect(x: position.origin.x, y: position.origin.y-tableView.contentOffset.y, width: position.width, height: position.height)
        hitToPushDetail = recipes.hits[indexPath.row]
        var scrollStart: Bool = false
        let positionXScroll = tableView.contentOffset.y
        let positionXCell = tableView.rectForRow(at: indexPath).origin.y
        
        if positionXCell-44 < positionXScroll {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            scrollStart = true
        }
        else if positionXScroll+self.view.frame.size.height-48 < (CGFloat(indexPath.row+1)*CellRecipe.heightRowRecipe) {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            scrollStart = true
        }
        //print("positionXScroll : \(positionXScroll)")
        //print("positionXCell : \(positionXCell)")
        //print("positionXScroll+Frame : \(positionXScroll+self.view.frame.size.height-50)")
        //print("positionXPositionBas : \((CGFloat(indexPath.row+1)*CellRecipe.heightRowRecipe))")
        //print("position cellule simple: \(tableView.rectForRow(at: indexPath))")
        //print("position cellule       : \(tableView.convert(tableView.rectForRow(at: indexPath), to: super.view))")
        //print("position scroll: \(tableView.contentOffset)")
        //let cell: CellRecipe = tableView.dequeueReusableCell(withIdentifier: "cellRecipe", for: indexPath) as! CellRecipe
//            cell.selectCell()
            //tableView.reloadData()
//        }
//        if let cell = (tableView.cellForRow(at: indexPath) as! CellRecipe) {
        
        //tableView.deselectRow(at: indexPath, animated: false)
        if !scrollStart {
            let detailRecipeView: DetailRecipeView = DetailRecipeView(hit: hitToPushDetail, positionImage: positionImageToPushDetail)
            detailRecipeView.modalPresentationStyle = .overCurrentContext
            present(detailRecipeView, animated: false) { }
        }
        //let deteil: UIViewController = UIViewController()
        //self.navigationController?.pushViewController(deteil, animated: false)
        //let search: SearchViewController = SearchViewController()
        //self.navigationController?.pushViewController(search, animated: false)
        //super.navigationController?.pushViewController(detailRecipeView, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellRecipe.heightRowRecipe
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.hits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cellRecipe = CellRecipe(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: CellRecipe.heightRowRecipe), hit: recipes.hits[indexPath.row])
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        //let cell: CellRecipe = tableView.dequeueReusableCell(withIdentifier: "cellRecipe", for: indexPath, hit: recipes.hits[indexPath.row]) as! CellRecipe
        
        let cell: CellRecipe = CellRecipe(style: .default, reuseIdentifier: "cellRecipe", hit: recipes.hits[indexPath.row]) 
        //cell.setHit(hit: recipes.hits[indexPath.row], stored: self.stored)
        
        //;(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100), hit: recipes.hits[indexPath.row])
        /*let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height:40))
        cell.addSubview(label)
        label.text = recipes.hits[indexPath.row].recipe.label
        */
        //cell.contentView.setNeedsLayout()
        //cell.contentView.layoutIfNeeded()
        return cell
    }

}
