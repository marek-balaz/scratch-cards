//
//  UIView+360Rotation.swift
//  Urbi
//
//  Created by Marek Baláž on 19/08/2022.
//  Copyright © 2022 Elmolis. All rights reserved.
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
