//
//  GradientView.swift
//  dice
//
//  Created by Alex Fish on 05/03/2015.
//  Copyright (c) 2015 Dice FM Ltd. All rights reserved.
//

import UIKit

/**
 *  Displays a gradient
 */
class GradientView: UIView {

    /// The gradient layer
    let gradient = CAGradientLayer()

    @IBInspectable var topColor: UIColor = UIColor.clear
    @IBInspectable var bottomColor: UIColor = UIColor(white: 0, alpha: 0.6)
    @IBInspectable var gradientStartPoint: CGPoint = CGPoint(x: 0.5, y: 0.0)
    @IBInspectable var gradientEndPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)

    /// The colors in the gradient, must be CGColor refs
    var colors: [UIColor] {
        get {
            return [
                topColor,
                bottomColor
            ]
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
    }
}

private extension GradientView {

    func setup() {
        gradient.startPoint = gradientStartPoint
        gradient.endPoint   = gradientEndPoint
        gradient.colors     = colors.map { $0.cgColor }
        gradient.frame      = self.bounds

        layer.addSublayer(gradient)
    }
}
