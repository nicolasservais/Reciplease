//
//  ListIngredientTableView.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 12/10/2021.
//

import UIKit

final class ListTableViewController: UITableViewController {
    
    private var boardIngredient: [String] = []
    override func viewDidLoad() {
        self.view.backgroundColor = .white
    }
// MARK: Get Set
    func getIngredients() -> [String] {
        return boardIngredient
    }
    func addNewIngredient(value: String) {
        boardIngredient.append(value)
        self.tableView.reloadData()
    }
    func clearAllIngredients() {
        boardIngredient.removeAll()
        self.tableView.reloadData()
    }
// MARK: Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardIngredient.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height:40))
        cell.addSubview(label)
        label.text = boardIngredient[indexPath.row]
        label.textColor = .darkGray
        return cell
    }
}

