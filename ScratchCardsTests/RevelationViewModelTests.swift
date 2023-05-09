//
//  RevelationViewModelTests.swift
//  ScratchCardsTests
//
//  Created by Marek Baláž on 09/05/2023.
//

import Combine
import XCTest
@testable import ScratchCards

class RevelationViewModelTests: XCTestCase {

    var viewModel: RevelationViewModel!
    var scratchCardViewModel: ScratchCardViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        scratchCardViewModel = ScratchCardViewModel(scratchCard: ScratchCard(number: 1, generatedAt: Date()))
        viewModel = RevelationViewModel(scratchCardViewModel: scratchCardViewModel)
    }

    func testStartRevealAnimation() {

        let expectation = self.expectation(description: "reveal animation completed")
        
        viewModel.startRevealAnimation()
        
        viewModel.codeLblText.sink { codeLabel in
            XCTAssertNotEqual(codeLabel, UUID().uuidString)
        }.store(in: &cancellables)
        
        viewModel.tapeProgressViewProgress.sink { progress in
            XCTAssertLessThanOrEqual(progress, 1)
        }.store(in: &cancellables)
        
        viewModel.isLoading.sink { state in
            switch state {
            case .isLoading:
                XCTAssertTrue(true)
            case .isFinished:
                XCTAssertTrue(true)
                expectation.fulfill()
            default:
                XCTFail("Unexpected state \(state)")
            }
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)

        XCTAssertNotNil(viewModel.scratchCardViewModel.scratchCard.playCode)
    }

    func testStopRevealAnimation() {

        viewModel.startRevealAnimation()
   
        wait(for: [], timeout: 1)
  
        viewModel.stopRevealAnimation()
        

        let tapeProgressSubscription = viewModel.tapeProgressViewProgress.sink { progress in
            XCTAssertEqual(progress, 1)
        }
        
        let isLoadingSubscription = viewModel.isLoading.sink { state in
            XCTAssertEqual(state, .normal)
        }
        
        tapeProgressSubscription.cancel()
        isLoadingSubscription.cancel()
        XCTAssertNil(viewModel.scratchCardViewModel.scratchCard.playCode)
    }
    
    func testGenerateUUID() {

        let uuid1 = viewModel.generateUUID()
        let uuid2 = viewModel.generateUUID()
        
        XCTAssertNotNil(UUID(uuidString: uuid1))
        XCTAssertNotNil(UUID(uuidString: uuid2))
        XCTAssertNotEqual(uuid1, uuid2)
    }
}
