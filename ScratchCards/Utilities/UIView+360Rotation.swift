//
//  UIView+360Rotation.swift
//  ScratchCards
//
//  Created by Marek Baláž on 07/05/2023.
//

import Foundation
import UIKit

extension UIView {
    
    func rotate360Degrees(duration: CFTimeInterval = 2) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
}
