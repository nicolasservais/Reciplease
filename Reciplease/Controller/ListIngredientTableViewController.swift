//
//  ListIngredientTableView.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 12/10/2021.
//

import UIKit

final class ListTableViewController: UITableViewController {
    
    private var boardIngredient: [String] = []
    
    func getIngredients() -> [String] {
        return boardIngredient
    }
    func addNewIngredient(value: String) {
        boardIngredient.append(value)
        loadView()
    }
    func clearAllIngredients() {
        boardIngredient.removeAll()
        loadView()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardIngredient.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height:40))
        cell.addSubview(label)
        label.text = boardIngredient[indexPath.row]
        return cell
    }

}

