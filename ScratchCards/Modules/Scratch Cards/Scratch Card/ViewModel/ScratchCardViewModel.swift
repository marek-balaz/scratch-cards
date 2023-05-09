//
//  ScratchCardViewModel.swift
//  ScratchCards
//
//  Created by Marek Baláž on 08/05/2023.
//

import Foundation
import Combine

enum ScratchCardState {
    case generated
    case revealed
    case activated
}

class ScratchCardViewModel: ViewModelType {
    
    @Published var scratchCard: ScratchCard
    @Published var scratchCardState: ScratchCardState = .generated
    
    let titleText = NSLocalizedString("scratch_card_title", comment: "")
    let playCodeText = NSLocalizedString("scratch_card_play_code_title", comment: "")
    
    var scratchCardUpdated = PassthroughSubject<ScratchCard, Never>()
    
    var activateBtnAction: (() -> Void)!
    var revealBtnAction: (() -> Void)!
    
    var activateBtnNavigateAction: (() -> Void)!
    var revealBtnNavigateAction: (() -> Void)!
    
    init(scratchCard: ScratchCard) {
        self.scratchCard = scratchCard
    }
    
    func bind() {
    }
    
    func getScratchCardStateText() -> String {
        switch scratchCardState {
        case .generated:
            return "\(NSLocalizedString("scratch_card_subtitle_generated", comment: "")) \(scratchCard.generatedAt.format())"
        case .revealed:
            if let revealedAt = scratchCard.revealedAt {
                return "\(NSLocalizedString("scratch_card_subtitle_revealed", comment: "")) \(revealedAt.format())"
            } else {
                return "Revelation unknown."
            }
        case .activated:
            if let activatedAt = scratchCard.activatedAt {
                return "\(NSLocalizedString("scratch_card_subtitle_activated", comment: "")) \(activatedAt.format())"
            } else {
                return "Activation unknown."
            }
        }
    }
    
    func getScratchCardNavigateBtn() -> (type: StandardButtonStyle, title: String, action: (()-> Void), hasImage: Bool)? {
        switch scratchCardState {
        case .generated:
            return (type: .secondaryActive, title: NSLocalizedString("scratch_card_navigate_reveal_button", comment: ""), action: revealBtnNavigateAction, hasImage: true)
        case .revealed:
            return (type: .primaryActive, title: NSLocalizedString("scratch_card_navigate_activate_button", comment: ""), action: activateBtnNavigateAction, hasImage: true)
        case .activated:
            return nil
        }
    }
    
    func getScratchCardBtn() -> (type: StandardButtonStyle, title: String, action: (()-> Void), hasImage: Bool)? {
        switch scratchCardState {
        case .generated:
            return (type: .secondaryActive, title: NSLocalizedString("scratch_card_reveal_button", comment: ""), action: revealBtnAction, hasImage: false)
        case .revealed:
            return (type: .primaryActive, title: NSLocalizedString("scratch_card_activate_button", comment: ""), action: activateBtnAction, hasImage: false)
        case .activated:
            return nil
        }
    }
    
}
