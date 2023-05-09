//
//  ActivationViewModelTests.swift
//  ScratchCardsTests
//
//  Created by Marek Baláž on 09/05/2023.
//

import Combine
import XCTest
@testable import ScratchCards

class ActivationViewModelTests: XCTestCase {
    
    var activationServiceMock: ActivationServiceMock!
    var viewModel: ActivationViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    func testActivateWithValidVersion() {
        
        let scratchCardViewModel = ScratchCardViewModel(scratchCard: ScratchCard(number: 1, generatedAt: Date(), revealedAt: Date()))
        activationServiceMock = ActivationServiceMock(versions: Versions(ios: "6.2"), statusCode: 200)
        viewModel = ActivationViewModel(scratchCardViewModel: scratchCardViewModel, activationService: activationServiceMock)
        
        viewModel.scratchCardViewModel.scratchCard.playCode = UUID().uuidString
        
        viewModel = ActivationViewModel(
            scratchCardViewModel: viewModel.scratchCardViewModel,
            activationService: activationServiceMock
        )
        
        let expectation = XCTestExpectation(description: "Activation succeeded")
        viewModel.scratchCardViewModel.scratchCardUpdated
            .sink { updatedScratchCard in
                if updatedScratchCard.activatedAt != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.activate()

        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(viewModel.scratchCardViewModel.scratchCard.activatedAt)
        XCTAssertEqual(viewModel.scratchCardViewModel.scratchCardState, .activated)
    }
    
    func testActivateWithInvalidVersion() {
        
        let scratchCardViewModel = ScratchCardViewModel(scratchCard: ScratchCard(number: 1, generatedAt: Date(), revealedAt: Date()))
        scratchCardViewModel.scratchCardState = .revealed
        activationServiceMock = ActivationServiceMock(versions: Versions(ios: "6.0"), statusCode: 200)
        viewModel = ActivationViewModel(scratchCardViewModel: scratchCardViewModel, activationService: activationServiceMock)
        
        viewModel.scratchCardViewModel.scratchCard.playCode = UUID().uuidString
        
        viewModel = ActivationViewModel(
            scratchCardViewModel: viewModel.scratchCardViewModel,
            activationService: activationServiceMock
        )
        
        let expectation = XCTestExpectation(description: "Activation failed")
        viewModel.versionError
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.activate()

        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(viewModel.scratchCardViewModel.scratchCard.activatedAt)
        XCTAssertEqual(viewModel.scratchCardViewModel.scratchCardState, .revealed)
    }
    
}
