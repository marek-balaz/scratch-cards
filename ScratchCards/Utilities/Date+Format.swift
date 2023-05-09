//
//  Date+Format.swift
//  ScratchCards
//
//  Created by Marek Baláž on 08/05/2023.
//

import Foundation

extension Date {
    
    /// MMM d, yyyy, HH:mm
    func format() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "MMM d, yyyy, HH:mm"
        return dateFormatter.string(from: self)
    }
    
}
