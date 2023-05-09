//
//  Fonts.swift
//  ScratchCards
//
//  Created by Marek Baláž on 07/05/2023.
//

import Foundation
import UIKit

extension UIFont
{
    // H1
    static func h1() -> UIFont {
        return UIFont.init(name: "Kanit-Bold", size: 24)!
    }
    
    // Text
    static func text() -> UIFont {
        return UIFont.init(name: "Kanit-Regular", size: 16)!
    }
    
    // Text-attention
    static func textAttention() -> UIFont {
        return UIFont.init(name: "Kanit-Bold", size: 16)!
    }
    
    // Label
    static func label() -> UIFont {
        return UIFont.init(name: "Kanit-Medium", size: 14)!
    }
    
}
