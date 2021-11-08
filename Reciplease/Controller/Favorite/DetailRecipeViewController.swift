//
//  DetailRecipeView.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 22/10/2021.
//

import UIKit

final class DetailRecipeViewController: UIViewController, UIScrollViewDelegate {
    
    private let positionContainer: CGRect
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    private let labelRecipe: UILabel = UILabel()
    private let imageRecipeView: UIImageView = UIImageView()
    private let recipe: Recipes.hits.recipe
    
    private var containerImageView: UIView = UIView()
    private var offsetImage: CGFloat = 0
    
    private var containerIngredient: UIView = UIView()
    private var cellulesIngredient: [UILabel] = []
    
    private var scrollView: UIScrollView = UIScrollView()
    private var heightCellLabel: CGFloat = 44
    
    private let containerInformationView: UIView = UIView()
    private var labelInformationRating: UILabel = UILabel()
    private var labelInformationDuration: UILabel = UILabel()
    private var imageRating: UIImageView = UIImageView()
    private var imageClock: UIImageView = UIImageView()
    
    private var scrollStart: Bool = false
    private let animationDuration: CGFloat = 0.3
    private var gradientTransformRatio: CGFloat = 5.3
    
    private var starButton: StarButton = StarButton()
    private var stored: Bool
    
    private var directionButton: UIButton = UIButton()
    private let heightDirectionButton: CGFloat = 40
    
    init(hit: Recipes.hits, positionContainer: CGRect, offset: CGFloat, stored: Bool) {
        self.stored = stored
        self.offsetImage = offset
        self.recipe = hit.recipe
        self.positionContainer = positionContainer
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        return nil
        //fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recipe"
        self.view.isOpaque = true
        self.view.backgroundColor = .clear
        
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.6, 1.0]

        labelRecipe.textColor = .white
        labelRecipe.textAlignment = .center
        labelRecipe.numberOfLines = 2
        
        imageRecipeView.image = UIImage(named: "NoImage")
        
        containerImageView.backgroundColor = .clear
        containerImageView.layer.addSublayer(gradientLayer)
        containerImageView.layer.cornerRadius = 16
        containerImageView.layer.borderWidth = 4
        containerImageView.layer.borderColor = UIColor.white.cgColor
        containerImageView.clipsToBounds = true
        containerImageView.insertSubview(imageRecipeView, at: 0)
        
        containerInformationView.backgroundColor = .darkGray
        containerInformationView.layer.cornerRadius = 16
        containerInformationView.layer.borderWidth = 1.5
        containerInformationView.layer.borderColor = UIColor.white.cgColor
        containerInformationView.clipsToBounds = true
        imageRating = UIImageView(image: UIImage(named: "Like"))
        imageClock =  UIImageView(image: UIImage(named: "Clock"))
        imageRating.contentMode = .scaleAspectFill
        imageClock.contentMode = .scaleAspectFill
        labelInformationRating.textColor = .white
        labelInformationDuration.textColor = .white
        labelInformationRating.text = "\(recipe.yield)"
        labelInformationDuration.text = "\(Int(recipe.totalTime))m"
        containerInformationView.addSubview(imageRating)
        containerInformationView.addSubview(imageClock)
        containerInformationView.addSubview(labelInformationRating)
        containerInformationView.addSubview(labelInformationDuration)
        
        starButton = StarButton( primaryAction: UIAction { [self] _ in self.clicStarButton() })
        starButton.accessibilityIdentifier = "starButton"

        scrollView.accessibilityIdentifier = "scroll"
        scrollView.addSubview(containerImageView)
        scrollView.addSubview(labelRecipe)
        scrollView.addSubview(containerInformationView)
        scrollView.addSubview(starButton)

        labelRecipe.text = recipe.label
        getimage()
        
        containerIngredient.backgroundColor = .white
        containerIngredient.layer.cornerRadius = 16
        containerIngredient.layer.borderWidth = 4
        containerIngredient.layer.borderColor = UIColor.white.cgColor
        containerIngredient.clipsToBounds = true
        scrollView.delegate = self
        scrollView.insertSubview(containerIngredient, at: 0)
        
        directionButton = UIButton( primaryAction: UIAction { [self] _ in self.clicDirectionButton() })
        directionButton.layer.cornerRadius = 12
        directionButton.backgroundColor = .systemGreen
        directionButton.tintColor = .white
        directionButton.setTitle("Get directions", for: .normal)
        directionButton.accessibilityIdentifier = "directionButton"

        scrollView.insertSubview(directionButton, at: 0)

        self.view.addSubview(scrollView)
        addIngredients()
        for label in cellulesIngredient {
            containerIngredient.insertSubview(label, at: 0)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeView(_:)))
            self.view.addGestureRecognizer(tapGesture)
        addNotifications()
        initialDraw()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("existRecipe"), object: recipe)
    }
    override func viewDidAppear(_ animated: Bool) {
        startMoveInView()
    }
// MARK: Notification
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func addNotifications() {
        NotificationCenter.default.addObserver( self, selector: #selector(validateAddRecipe),
                                                name: Notification.Name(rawValue: "validateAddRecipe"),
                                                object: nil)
        NotificationCenter.default.addObserver( self, selector: #selector(validateDeleteRecipe),
                                                name: Notification.Name(rawValue: "validateDeleteRecipe"),
                                                object: nil)
        NotificationCenter.default.addObserver( self, selector: #selector(existRecipe),
                                                name: Notification.Name(rawValue: "existRecipeInDetail"),
                                                object: nil)
    }
    @objc private func existRecipe(notification: Notification) {
        if let exist: Bool = notification.object as? Bool {
            if exist {
                starButton.fillColor = .yellow
            } else {
                starButton.fillColor = .white
            }
        }
    }
    @objc private func validateAddRecipe(notification: Notification) {
        if let recipe: Recipes.hits.recipe = notification.object as? Recipes.hits.recipe {
            if recipe.label == self.recipe.label {
                starButton.fillColor = .yellow
            }
        }
    }
    @objc private func validateDeleteRecipe(notification: Notification) {
        starButton.fillColor = .white
    }
// MARK: Method
    func initialDraw() {
        scrollView.constraintToSafeArea()
        //scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        imageRecipeView.frame = CGRect(x: 0, y: offsetImage, width: self.positionContainer.width, height: self.positionContainer.width)
        containerImageView.frame = positionContainer
        labelRecipe.frame = CGRect(x: 5, y: self.positionContainer.origin.y+self.positionContainer.height-46, width: self.positionContainer.width-10, height: 44)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.positionContainer.width, height: CellRecipe.heightRowRecipe)
        containerIngredient.frame = CGRect(x: positionContainer.origin.x, y: positionContainer.origin.y+positionContainer.height-44, width: positionContainer.width, height: 44)
        
        containerInformationView.frame = CGRect(x: self.positionContainer.width+90, y: 10, width: 80, height: 70)
        labelInformationRating.frame = CGRect(x: 6, y: 2, width: 50, height: 40)
        labelInformationDuration.frame = CGRect(x: 6, y: 27, width: 50, height: 40)
        imageRating.frame = CGRect(x: 48, y: 5, width: 30, height: 30)
        imageClock.frame = CGRect(x: 48, y: 33, width: 30, height: 30)
        
        starButton.frame = CGRect(x: -50, y: 10, width: 40, height: 40)
        directionButton.frame = CGRect(x: 4, y: self.positionContainer.origin.y+self.positionContainer.height-heightDirectionButton, width: self.positionContainer.width-8, height: heightDirectionButton)
    }
    private func addIngredients() {
        cellulesIngredient.removeAll()
        let title:UILabel = UILabel(frame: CGRect(x: 4, y: 0, width: self.view.frame.width-8, height: heightCellLabel))
        title.layer.borderColor = UIColor.white.cgColor
        title.layer.cornerRadius = 14
        title.layer.borderWidth = 4
        title.clipsToBounds = true
        title.textAlignment = .center
        title.numberOfLines = 1
        title.backgroundColor = .darkGray
        title.textColor = .white
        title.text = "Ingredients"
        cellulesIngredient.append(title)
        for ingredient in recipe.ingredientLines {
            // print("ingredient : \(ingredient)")
            let label:UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: self.view.frame.width-20, height: heightCellLabel))
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 2
            label.backgroundColor = .white
            label.textColor = .darkGray
            label.text = ingredient
            label.layer.addSublayer(addLineBottomCenter(widthPage: self.view.frame.width-20, width: 40))
            cellulesIngredient.append(label)
        }
    }
    private func addLineBottomCenter(widthPage: CGFloat, width: CGFloat) -> CAShapeLayer{
        let bezier: UIBezierPath = UIBezierPath()
        bezier.move(to: CGPoint(x: (widthPage/2)-(width/2), y: heightCellLabel+2))
        bezier.addLine(to: CGPoint(x: (widthPage/2)+(width/2), y: heightCellLabel+2))
        let shape: CAShapeLayer = CAShapeLayer()
        shape.path = bezier.cgPath
        shape.lineWidth = 1.5
        shape.lineCap = .round
        shape.strokeColor = UIColor.gray.cgColor
        return shape
    }
    private func startMoveInView() {
        gradientTransformRatio = positionContainer.width/CellRecipe.heightRowRecipe/4*7
        moveGradient(duration: animationDuration, transformFrom: 1, transformTo: gradientTransformRatio, locationFrom: [0.5, 1.0], locationTo: [0.3, 1.0])
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
            self.view.backgroundColor = .darkGray
            self.imageRecipeView.frame.origin.y = 0
            self.containerImageView.layer.borderColor = UIColor.darkGray.cgColor
            self.containerImageView.frame = CGRect(x: 0, y: 0,
                                                   width: self.positionContainer.width,
                                                   height: self.positionContainer.width)
            self.labelRecipe.frame = CGRect(x: 5, y: self.imageRecipeView.frame.width-46,
                                            width: self.imageRecipeView.frame.width-10,
                                            height: 44)
            self.containerIngredient.frame = CGRect(x: 0, y: self.positionContainer.width+self.heightDirectionButton+4,
                                                    width: self.positionContainer.width,
                                                    height: CGFloat(self.cellulesIngredient.count*44)+8)
            self.containerIngredient.layer.borderColor = UIColor.darkGray.cgColor
            for index in 0...self.cellulesIngredient.count-1 {
                let label = self.cellulesIngredient[index]
                label.frame.origin.y = (CGFloat(index)*self.heightCellLabel)+4
            }
            self.directionButton.frame.origin.y = self.positionContainer.width+2
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: (CGFloat(self.cellulesIngredient.count)*self.heightCellLabel)+self.positionContainer.width+8+self.heightDirectionButton)

        } completion: { _ in

        }
        UIView.animate(withDuration: animationDuration, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.containerInformationView.frame.origin.x = self.positionContainer.width-90
            self.starButton.frame.origin.x = 10
        }, completion: nil)

    }
    private func stopMoveInView() {
        moveGradient(duration: animationDuration, transformFrom: gradientTransformRatio, transformTo: 1, locationFrom: [0.3, 1.0], locationTo: [0.5, 1.0])
        if self.stored && self.starButton.fillColor == .white {
            NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil)
        }
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
            self.view.backgroundColor = .clear
            self.imageRecipeView.frame.origin.y = self.offsetImage
            self.containerImageView.layer.borderColor = UIColor.white.cgColor
            self.containerImageView.frame = self.positionContainer
            self.labelRecipe.frame = CGRect(x: 5, y: self.positionContainer.origin.y+self.positionContainer.height-46,
                                            width: self.positionContainer.width-10,
                                            height: 44)
            self.containerIngredient.frame = CGRect(x: 0, y: self.positionContainer.origin.y+self.positionContainer.height-44,
                                                    width: self.positionContainer.width,
                                                    height: 44)
            self.containerIngredient.layer.borderColor = UIColor.white.cgColor
            for index in 0...self.cellulesIngredient.count-1 {
                let label = self.cellulesIngredient[index]
                label.frame.origin.y = 0
            }
            self.containerInformationView.frame.origin.x = self.positionContainer.width+90
            self.containerInformationView.frame.origin.y = self.positionContainer.origin.y
            self.starButton.frame.origin.x = -50
            self.starButton.frame.origin.y = self.positionContainer.origin.y
            self.directionButton.frame.origin.y = self.positionContainer.origin.y+self.positionContainer.height-self.heightDirectionButton
        } completion: { _ in
            if self.stored && self.starButton.fillColor == .white {
                //NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil)
                UIView.animate(withDuration: self.animationDuration, delay: 0, options: .curveEaseInOut) {
                    self.containerIngredient.frame.origin.x = -self.positionContainer.width-90
                    self.containerImageView.frame.origin.x = -self.positionContainer.width-90
                    self.labelRecipe.frame.origin.x = -self.positionContainer.width-90
                    self.directionButton.frame.origin.x = -self.positionContainer.width-90
                } completion: { _ in
                    self.dismiss(animated: false) {
                    }
                }
            } else {
                self.dismiss(animated: false) {}
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: false)
    }
    private func moveGradient(duration: CGFloat, transformFrom: CGFloat, transformTo: CGFloat, locationFrom: [CGFloat], locationTo: [CGFloat]) {
        let gradientAnimation = CABasicAnimation(keyPath: "transform.scale.y")
        gradientAnimation.fromValue = transformFrom
        gradientAnimation.toValue = transformTo
        gradientAnimation.duration = duration
        gradientAnimation.repeatCount = 1
        gradientAnimation.isRemovedOnCompletion = false
        gradientAnimation.fillMode = .forwards
        gradientAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        gradientLayer.add(gradientAnimation, forKey: "anim")
        let gradientAnimation2 = CABasicAnimation(keyPath: "location")
        gradientAnimation2.fromValue = locationFrom
        gradientAnimation2.toValue = locationTo
        gradientAnimation2.duration = duration
        gradientAnimation2.repeatCount = 1
        gradientAnimation2.isRemovedOnCompletion = false
        gradientAnimation2.fillMode = .forwards
        gradientAnimation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        gradientLayer.add(gradientAnimation2, forKey: "anim2")
    }
    private func getimage() {
        imageRecipeView.downloaded(from: recipe.image, contentMode: .scaleAspectFill)
    }
    @objc func closeView(_ sender:UITapGestureRecognizer) {
        if scrollView.contentOffset.y > 0 {
            scrollStart = true
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else {
            stopMoveInView()
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollStart {
            scrollStart = false
            stopMoveInView()
        }
    }
// MARK: Action
    private func clicStarButton() {
        if starButton.fillColor == .white {
            NotificationCenter.default.post(name: Notification.Name("addRecipe"), object: recipe)
        } else if starButton.fillColor == .yellow {
            NotificationCenter.default.post(name: Notification.Name("deleteRecipe"), object: recipe)
        }
    }
    private func clicDirectionButton() {
        
        if let url = URL(string: recipe.url) {
            UIApplication.shared.open(url)
        }
    }
    /*
    func getBezierStart(rect: CGRect, radius: CGFloat) -> UIBezierPath {
        let bezier: UIBezierPath = UIBezierPath()
        bezier.move(to: CGPoint(x: rect.origin.x+rect.width/2, y: 0))
        bezier.addLine(to: CGPoint(x: rect.origin.x+rect.width-radius, y: rect.origin.y))
        bezier.addArc(withCenter: CGPoint(x: rect.origin.x+rect.width-radius, y: rect.origin.y+radius), radius: radius, startAngle: -(CGFloat.pi/2), endAngle: 0, clockwise: true)
        bezier.addLine(to: CGPoint(x: rect.origin.x+rect.width, y: rect.origin.y+rect.height-radius))
        bezier.addArc(withCenter: CGPoint(x: rect.origin.x+rect.width-radius, y: rect.origin.y+rect.height-radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
        bezier.addLine(to: CGPoint(x: rect.origin.x+radius, y: rect.origin.y+rect.height))
        bezier.addArc(withCenter: CGPoint(x: rect.origin.x+radius, y: rect.origin.y+rect.height-radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
        bezier.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y+radius))
        bezier.addArc(withCenter: CGPoint(x: rect.origin.x+radius, y: rect.origin.y+radius), radius: radius, startAngle: CGFloat.pi, endAngle: CGFloat.pi/2*3, clockwise: true)
        bezier.addLine(to: CGPoint(x: rect.origin.x+rect.width/2, y: 0))

        return bezier
    }*/
}
