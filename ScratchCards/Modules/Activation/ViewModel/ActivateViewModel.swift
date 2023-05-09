//
//  ActivateViewModel.swift
//  ScratchCards
//
//  Created by Marek Baláž on 08/05/2023.
//

import Foundation
import Combine

class ActivationViewModel: ViewModelType {
    
    @Published var scratchCardViewModel: ScratchCardViewModel
    
    var activationService: ActivationServiceProtocol
    var isLoading = PassthroughSubject<StandarbButtonState, Never>()
    var networkError = PassthroughSubject<String, Never>()
    var versionError = PassthroughSubject<(title: String, desc: String), Never>()
    
    let minimalVersion = "6.1"
    
    private var cancellables = Set<AnyCancellable>()
    
    init(scratchCardViewModel: ScratchCardViewModel, activationService: ActivationServiceProtocol) {
        self.scratchCardViewModel = scratchCardViewModel
        self.activationService = activationService
    }
    
    func bind() {
    }
    
    func activate() {
        
        guard let playCode = scratchCardViewModel.scratchCard.playCode else {
            Log.d("Missing play code.")
            return
        }

        isLoading.send(.isLoading)
        activationService.getVersions(playCode: playCode)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .failure(let error):
                    self.isLoading.send(.normal)
                    self.networkError.send(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] versions, statusCode in
                guard let self = self else { return }
                
                switch statusCode {
                case 200..<300:
                    if self.isVersionValid(versions.ios) {
                        self.isLoading.send(.isFinished)
                        self.scratchCardViewModel.scratchCard.activatedAt = Date()
                        self.scratchCardViewModel.scratchCardState = .activated
                        self.scratchCardViewModel.scratchCardUpdated.send(self.scratchCardViewModel.scratchCard)
                    } else {
                        self.isLoading.send(.failed)
                        self.versionError.send(("Activation failed", "App requires OS version of \(self.minimalVersion) or higher."))
                    }
                case 300..<600:
                    self.isLoading.send(.normal)
                    self.networkError.send(String(statusCode))
                default:
                    self.isLoading.send(.normal)
                    self.networkError.send("Unknown error occured.")
                }

            })
            .store(in: &cancellables)
        
    }
    
    func isVersionValid(_ newVersion: String) -> Bool {
        return newVersion.compare(minimalVersion, options: .numeric) == .orderedDescending
    }
    
}

