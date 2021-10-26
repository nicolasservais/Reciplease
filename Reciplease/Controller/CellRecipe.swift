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
    private var previousOffset: CGFloat = 0
    private var summaryOffset: CGFloat = 0
    
    private var containerView: UIView = UIView()

    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, hit: Recipes.hits) {
        //self.recipe = hit.recipe
        self.recipe = hit.recipe //Recipes.hits.recipe(label: "", image: "", totalTime: 0, yield: 0)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        redraw()
    }
    func getImage() -> UIImage {
        return imageRecipeView.image ?? UIImage()
    }
    private func loadView() {
        self.backgroundColor = .white
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.6, 1.0]

        labelRecipe.textColor = .white
        labelRecipe.textAlignment = .center
        
        imageRecipeView.layer.addSublayer(gradientLayer)
        imageRecipeView.layer.cornerRadius = 12
        imageRecipeView.layer.borderWidth = 4
        imageRecipeView.layer.borderColor = UIColor.white.cgColor
        imageRecipeView.clipsToBounds = true
        self.addSubview(imageRecipeView)
        self.addSubview(labelRecipe)
        //self.addSubview(labelDuration)

        labelRecipe.text = recipe.label
        //imageRecipeView.translatesAutoresizingMaskIntoConstraints = false
        getimage()
        //imageRecipeView.image = image.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        //imageRecipeView.contentMode = .redraw
    }
    private func redraw() {
        //print("Frame: \(self.frame)")
        labelRecipe.frame = CGRect(x: 3, y: CellRecipe.heightRowRecipe-44, width: self.frame.width-6, height: 44)
        imageRecipeView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: CellRecipe.heightRowRecipe)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: CellRecipe.heightRowRecipe)
    }
    override func setNeedsDisplay() {
        //print("SetNeedDisplay : \(self.bounds)")
    }
    func cellOnTableView(tableView: UITableView, view: UIView, offset: CGFloat) {
        
        let rectInSuperview: CGRect = tableView.convert(self.frame, to: view)

        self.currentOffset = -offset/10
        print("offset: \(currentOffset)")
        
        imageRecipeView.image?.draw(at: CGPoint(x: 0, y: currentOffset/10))
        //imageRecipeView.bounds = CGRect(x: imageRecipeView.bounds.origin.x, y: imageRecipeView.bounds.origin.y, width: imageRecipeView.bounds.width, height: imageRecipeView.bounds.height)
        //imageRecipeView.transform = CGAffineTransform(translationX: 20, y: 20)
        //imageRecipeView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3)
        //imageRecipeView.image! = image.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        //let difference: CGFloat = self.currentOffset-self.previousOffset;
        //print("difference \(difference)")

        /*let distanceFromOrigin: CGFloat = 8.0
        let difference: CGFloat = self.currentOffset-self.previousOffset;

        if self.summaryOffset <= rectInSuperview.height {
            self.summaryOffset = self.summaryOffset + difference;
        } else {
            self.summaryOffset = 0
        }

        var imageRect: CGRect = self.imageRecipeView.frame
        imageRect.origin.y = (self.summaryOffset)+distanceFromOrigin
        self.imageRecipeView.frame = imageRect
        self.previousOffset = self.currentOffset
        */
    }
    
    func selectCell() {
        print("select cell")
        imageRecipeView.layer.borderColor = UIColor.red.cgColor
        //self.backgroundColor = .red

    }

    private func getimage() {
        //if !imageDownloaded {
            //print("image: \(recipe.image)")
            //imageDownloaded =
        //imageRecipeView.downloaded(from: recipe.image, contentMode: .scaleAspectFill)
        imageRecipeView.downloaded(from: recipe.image, contentMode: .scaleAspectFill)
        //}
    }
    
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode) {
        guard let url = URL(string: link) else { return}
        return downloaded(from: url, contentMode: mode)
    }
}
/*
extension UIImageView {
    func load(url: URL) {
        print("0-URL: \(url) ")

        DispatchQueue.global().async { [weak self] in
            print("1-URL: \(url) ")
            if let data = try? Data(contentsOf: url) {
                print("2-URL: \(url) ")
                if let image = UIImage(data: data) {
                    print("3-URL: \(url) ")
                    DispatchQueue.main.async {
                        print("4-URL: \(url) ")
                        self?.image = image
                    }
                }
            }
        }
    }
}
*/
