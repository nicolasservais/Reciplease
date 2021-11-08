//
//  AddIngredient.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 11/10/2021.
//

import Foundation
import UIKit

class AddIngredientView: UIView, UITextFieldDelegate {
    
    private let widthButton: CGFloat = 80
    private let heightButton: CGFloat = 40
    private let spaceIn: CGFloat = 8
    private let label: UILabel = UILabel()
    private let textField: UITextField = UITextField()
    private let buttonAdd: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    required init?(coder: NSCoder) {
        return nil
    }
    func loadView() {
        self.layer.cornerRadius = 12
        label.text = "What's in my fridge ?"
        label.textAlignment = .center
        label.textColor = .darkGray
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.textColor = .darkGray
        textField.textAlignment = .center
        textField.delegate = self
        textField.accessibilityIdentifier = "ingredient"
        textField.attributedPlaceholder = NSAttributedString(
            string: "Chicken or egg or salad ...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        buttonAdd.accessibilityIdentifier = "addIngredient"
        buttonAdd.layer.cornerRadius = 8
        buttonAdd.layer.backgroundColor = UIColor.systemGreen.cgColor
        buttonAdd.setTitle("Add", for: .normal)
        self.addSubview(label)
        self.addSubview(textField)
        self.addSubview(buttonAdd)
        self.backgroundColor = .white
    }
    func redraw(size: CGSize) {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: size.width, height: self.frame.height)
        label.frame = CGRect(x: spaceIn, y: spaceIn, width: size.width-spaceIn, height: heightButton)
        textField.frame = CGRect(x: spaceIn, y: heightButton+spaceIn, width: size.width-widthButton-(spaceIn*2), height: heightButton)
        buttonAdd.frame = CGRect(x: size.width-widthButton, y: heightButton+spaceIn, width: widthButton-spaceIn, height: heightButton)
    }
    func getText() -> String {
        guard let text = textField.text else { return "" }
        return text
    }
    func getButtonAdd() -> UIButton {
        return buttonAdd
    }
    func resetText() {
        textField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
