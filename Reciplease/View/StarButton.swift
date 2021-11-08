//
//  StarButton.swift
//  Reciplease
//
//  Created by Nicolas SERVAIS on 28/10/2021.
//

import UIKit

class StarButton: UIButton {
    private var cornerRadius: CGFloat = 2
    private var rotation: CGFloat = 54
    private var strokeColor = UIColor.darkGray
    var fillColor = UIColor.white               { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let r = rect.width / 2
        let rc = cornerRadius
        let rn = r * 0.9 - rc

        var cangle = rotation
        for i in 1 ... 5 {
            // compute center point of tip arc
            let cc = CGPoint(x: center.x + rn * cos(cangle * .pi / 180), y: center.y + rn * sin(cangle * .pi / 180))
            // compute tangent point along tip arc
            let p = CGPoint(x: cc.x + rc * cos((cangle - 72) * .pi / 180), y: cc.y + rc * sin((cangle - 72) * .pi / 180))
            if i == 1 {
                path.move(to: p)
            } else {
                path.addLine(to: p)
            }
            // add 144 degree arc to draw the corner
            path.addArc(withCenter: cc, radius: rc, startAngle: (cangle - 72) * .pi / 180, endAngle: (cangle + 72) * .pi / 180, clockwise: true)
            cangle += 144
        }
        path.close()
        path.lineWidth = 3
        strokeColor.setStroke()
        fillColor.setFill()
        path.stroke()
        path.fill()
   }
    
}
