//
//  DetailRecipeView.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 22/10/2021.
//

import UIKit

final class DetailRecipeView: UIViewController {
    
    private let positionImage: CGRect
    //private let textView: UITextView = UITextView()
    //private let bezierStart: UIBezierPath = UIBezierPath()
    //private let bezierStop: UIBezierPath = UIBezierPath()
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    private let labelRecipe: UILabel = UILabel()
    private let imageRecipeView: UIImageView = UIImageView()
    private let recipe: Recipes.hits.recipe

    
    init(hit: Recipes.hits, positionImage: CGRect) {
        self.recipe = hit.recipe
        self.positionImage = positionImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
        self.view.backgroundColor = .clear
        
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.6, 1.0]

        labelRecipe.textColor = .white
        labelRecipe.textAlignment = .center
        
        imageRecipeView.layer.addSublayer(gradientLayer)
        imageRecipeView.layer.cornerRadius = 12
        imageRecipeView.layer.borderWidth = 4
        imageRecipeView.layer.borderColor = UIColor.white.cgColor
        imageRecipeView.clipsToBounds = true
        self.view.addSubview(imageRecipeView)
        self.view.addSubview(labelRecipe)
        //self.addSubview(labelDuration)

        labelRecipe.text = recipe.label
        getimage()
        //redraw()
        
        //layerShape.mask = shape
        //shape.path = getBezierStart(rect: CGRect(x: 10, y: 10, width: 200, height: 200), radius: 10).cgPath
        //shape.strokeColor = UIColor.red.cgColor
        //layerShape.addSublayer(shape)
        //self.view.layer.addSublayer(layerShape)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeView(_:)))
            self.view.addGestureRecognizer(tapGesture)
        initialDraw()
    }
    override func viewDidAppear(_ animated: Bool) {
        startMoveInView()
    }
    private func startMoveInView() {
        
        //gradientLayer.speed = 5.5
        //gradientLayer.frame = CGRect(x: 0, y: 0, width: self.positionImage.width, height: self.positionImage.width)
        startGradient(duration: 0.3, transformFrom: 1, transformTo: 6.1, locationFrom: [0.6, 1.0], locationTo: [0.3, 1.0])
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.view.backgroundColor = .darkGray
            self.imageRecipeView.layer.borderColor = UIColor.darkGray.cgColor
            self.imageRecipeView.frame = CGRect(x: 0, y: 0, width: self.positionImage.width, height: self.positionImage.width)
            self.labelRecipe.frame = CGRect(x: 3, y: self.imageRecipeView.frame.width-44, width: self.imageRecipeView.frame.width-6, height: 44)
            //self.gradientLayer.frame = CGRect(x: 0, y: 0, width: self.positionImage.width, height: self.positionImage.width)
        } completion: { _ in

        }
    }
    private func stopMoveInView() {
        //gradientLayer.speed = 5.5
        startGradient(duration: 0.3, transformFrom: 6.1, transformTo: 1, locationFrom: [0.3, 1.0], locationTo: [0.6, 1.0])

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.view.backgroundColor = .clear
            self.imageRecipeView.layer.borderColor = UIColor.white.cgColor
            self.imageRecipeView.frame = self.positionImage
            self.labelRecipe.frame = CGRect(x: 3, y: self.positionImage.origin.y+self.positionImage.height-44, width: self.positionImage.width-6, height: 44)
            self.gradientLayer.frame = CGRect(x: 0, y: 0, width: self.positionImage.width, height: self.positionImage.height)
        } completion: { _ in
            self.dismiss(animated: false) {}
        }
    }
    private func startGradient(duration: CGFloat, transformFrom: CGFloat, transformTo: CGFloat, locationFrom: [CGFloat], locationTo: [CGFloat]) {
        let gradientAnimation = CABasicAnimation(keyPath: "transform.scale.y")
        gradientAnimation.fromValue = transformFrom //1
        gradientAnimation.toValue = transformTo//6.1 //positionImage.width/positionImage.height
        gradientAnimation.duration = duration
        gradientAnimation.repeatCount = 1
        gradientAnimation.isRemovedOnCompletion = false
        gradientAnimation.fillMode = .forwards
        gradientAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        gradientLayer.add(gradientAnimation, forKey: "anim")
        let gradientAnimation2 = CABasicAnimation(keyPath: "location")
        gradientAnimation2.fromValue = locationFrom//[0.6, 1.0]
        gradientAnimation2.toValue = locationTo//[0.3, 1.0] //positionImage.width/positionImage.height
        gradientAnimation2.duration = duration
        gradientAnimation2.repeatCount = 1//Float.infinity
        gradientAnimation2.isRemovedOnCompletion = false
        gradientAnimation2.fillMode = .forwards
        gradientAnimation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        gradientLayer.add(gradientAnimation2, forKey: "anim2")
        
    }
    private func getimage() {
            imageRecipeView.downloaded(from: recipe.image, contentMode: .scaleAspectFill)
    }

    func initialDraw() {
        imageRecipeView.frame = positionImage
        labelRecipe.frame = CGRect(x: 3, y: self.positionImage.origin.y+self.positionImage.height-44, width: self.positionImage.width-6, height: 44)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.positionImage.width, height: self.positionImage.height)


    }
    @objc func closeView(_ sender:UITapGestureRecognizer) {
        stopMoveInView()
    }
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
    }
}
