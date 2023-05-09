//
//  RevelationViewModel.swift
//  ScratchCards
//
//  Created by Marek Baláž on 09/05/2023.
//

import Foundation
import Combine

class RevelationViewModel: ViewModelType {
    
    @Published var scratchCardViewModel: ScratchCardViewModel
    
    private var scrambleTimer: AnyCancellable?
    private var tapeProgressTimer: AnyCancellable?
    private var tapeProgressDuration: Float = 0
    
    var codeLblText = PassthroughSubject<String, Never>()
    var tapeProgressViewProgress = PassthroughSubject<Float, Never>()
    var isLoading = PassthroughSubject<StandarbButtonState, Never>()
    
    let duration: Float = 2
    
    private var cancellables = Set<AnyCancellable>()
    
    init(scratchCardViewModel: ScratchCardViewModel) {
        self.scratchCardViewModel = scratchCardViewModel
    }
    
    func bind() {
    }
    
    func generateUUID() -> String {
        return UUID().uuidString
    }
    
    func startRevealAnimation() {
        tapeProgressDuration = duration
        isLoading.send(.isLoading)
        tapeProgressTimer = Timer.publish(every: 0.01, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.tapeProgressDuration <= 0 {
                    self.isLoading.send(.isFinished)
                    self.tapeProgressViewProgress.send(0)
                    self.tapeProgressTimer?.cancel()
                    self.scratchCardViewModel.scratchCard.playCode = self.generateUUID()
                    self.scratchCardViewModel.scratchCard.revealedAt = Date()
                    self.scratchCardViewModel.scratchCardState = .revealed
                    self.scratchCardViewModel.scratchCardUpdated.send(self.scratchCardViewModel.scratchCard)
                } else {
                    let progress = self.tapeProgressDuration / self.duration
                    self.tapeProgressViewProgress.send(progress)
                    self.codeLblText.send(String(UUID().uuidString.shuffled()))
                    self.tapeProgressDuration -= 0.01
                }
            }
    }
    
    func stopRevealAnimation() {
        tapeProgressTimer?.cancel()
        tapeProgressViewProgress.send(1)
        isLoading.send(.normal)
    }
    
}
