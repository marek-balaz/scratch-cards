//
//  ActivationServiceProtocol.swift
//  ScratchCards
//
//  Created by Marek Baláž on 08/05/2023.
//

import Foundation
import Combine

protocol ActivationServiceProtocol: AnyObject {
    
    var networkService: NetworkServiceProtocol { get }
    func getVersions(playCode: String) -> AnyPublisher<(response: Versions, statusCode: Int), Error>
    
}

class ActivationService: ActivationServiceProtocol {
    
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getVersions(playCode: String) -> AnyPublisher<(response: Versions, statusCode: Int), Error> {
        return networkService.request(url: O2API.url(path: "version", parameters: ["code" : playCode]), method: .get, body: nil, headers: O2API.headers())
    }
    
}
