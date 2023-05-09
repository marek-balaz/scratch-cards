//
//  ScratchCard.swift
//  ScratchCards
//
//  Created by Marek Baláž on 08/05/2023.
//

import Foundation

struct ScratchCard: Codable {

    let number: Int
    var playCode: String?
    let generatedAt: Date
    var revealedAt: Date?
    var activatedAt: Date?
    
}
