//
//  CellRecipe.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 18/10/2021.
//

import Foundation
import UIKit

final class CellRecipe: UITableViewCell {
    static let heightRowRecipe: CGFloat = 120
    private let imageRecipeView: UIImageView = UIImageView()
    private let labelRecipe: UILabel = UILabel()
    private let labelDuration: UILabel = UILabel()
    private var recipe: Recipes.hits.recipe
    private var imageDownloaded: Bool = false
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    
    private var currentOffset: CGFloat = 0
    private var containerView: UIView = UIView()
    private var widthImage: CGFloat = 0

    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, hit: Recipes.hits) {
        self.recipe = hit.recipe //Recipes.hits.recipe(label: "", image: "", totalTime: 0, yield: 0)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    override func layoutSubviews() {
        redraw()
    }
    private func loadView() {
        self.backgroundColor = .white
        imageRecipeView.image = UIImage(named: "NoImage")
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.6, 1.0]
        labelRecipe.textColor = .white
        labelRecipe.textAlignment = .center
        labelRecipe.numberOfLines = 2
        containerView.layer.addSublayer(gradientLayer)
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 4
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.clipsToBounds = true
        containerView.insertSubview(imageRecipeView, at: 0)
        self.addSubview(containerView)
        self.addSubview(labelRecipe)
        labelRecipe.text = recipe.label
        getimage()
    }
    private func redraw() {
        widthImage = self.frame.width
        labelRecipe.frame = CGRect(x: 5, y: CellRecipe.heightRowRecipe-46, width: self.frame.width-10, height: 44)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: CellRecipe.heightRowRecipe)
        containerView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: CellRecipe.heightRowRecipe)
        imageRecipeView.frame = CGRect(x: 0, y: -(((CellRecipe.heightRowRecipe)/2)+currentOffset), width: widthImage, height: widthImage)
    }
    func offsetImage(value: CGFloat) {
        self.currentOffset = value
        imageRecipeView.frame = CGRect(x: 0, y: -(((CellRecipe.heightRowRecipe)/2)+currentOffset), width: widthImage, height: widthImage)
    }
    func getOffsetImage() -> CGFloat {
        return -(((CellRecipe.heightRowRecipe)/2)+currentOffset)
    }
    private func getimage() {
        imageRecipeView.downloaded(from: recipe.image, contentMode: .scaleAspectFill)
    }
}
