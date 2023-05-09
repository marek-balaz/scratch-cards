//
//  ActivationServiceMock.swift
//  ScratchCardsTests
//
//  Created by Marek Baláž on 09/05/2023.
//

import Combine
import XCTest
@testable import ScratchCards

class ActivationServiceMock: ActivationServiceProtocol {
    
    var networkService: NetworkServiceProtocol = NetworkService()
    
    let versions: Versions
    let statusCode: Int
    let error: Error?
    
    init(versions: Versions, statusCode: Int, error: Error? = nil) {
        self.versions = versions
        self.statusCode = statusCode
        self.error = error
    }
    
    func getVersions(playCode: String) -> AnyPublisher<(response: Versions, statusCode: Int), Error> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Just((response: versions, statusCode: statusCode))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
}
