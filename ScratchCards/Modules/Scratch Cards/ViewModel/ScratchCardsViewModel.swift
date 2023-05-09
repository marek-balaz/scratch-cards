//
//  ScratchCardsViewModel.swift
//  ScratchCards
//
//  Created by Marek Baláž on 08/05/2023.
//

import Foundation
import Combine

class ScratchCardsViewModel: ViewModelType {
    
    @Published var scratchCards: [ScratchCard] = []
    @Published var cellViewModels: [ScratchCardViewModel] = []
    
    let scratchCardGeneratorService: ScratchCardGeneratorProtocol
    
    init(scratchCardGeneratorService: ScratchCardGeneratorProtocol) {
        self.scratchCardGeneratorService = scratchCardGeneratorService
        fetchData()
    }
    
    func bind() {
    }
    
    private func fetchData() {
        scratchCards.append(scratchCardGeneratorService.getScratchCard())
    }
    
}
