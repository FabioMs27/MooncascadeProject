//
//  UIView.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 25/02/21.
//

import UIKit

@IBDesignable
extension UIView {
    @IBInspectable
    var rounded: Bool {
        get { false }
        set {
            if newValue { roundView(frame.width/2) }
        }
    }
    @IBInspectable
    var cornerRadius: CGFloat {
        get { frame.width/2 }
        set { roundView(newValue) }
    }
}

extension UIView {
    func roundView(_ cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}
