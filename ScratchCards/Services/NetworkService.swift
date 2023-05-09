//
//  NetworkService.swift
//  ScratchCards
//
//  Created by Marek Baláž on 07/05/2023.
//

import Foundation
import Combine
import Alamofire

enum NetworkError: Error {
    case invalidRequest
    case invalidURL
    case invalidResponse
    case apiError
    case unknown
    case taskAlreadyExists
    case noInternetConnection
}

protocol NetworkServiceProtocol: AnyObject {
    func request<T: Decodable> (url: String, method: HTTPMethod, body: [String: AnyObject]?, headers: HTTPHeaders?) -> AnyPublisher<(response: T, statusCode: Int), Error>
}

struct TaskInfo {
    let url: String
    let request: DataRequest
}

class NetworkService: NetworkServiceProtocol {
    
    private var ongoingTasks: [TaskInfo] = []
    
    func request<T: Decodable> (url: String, method: HTTPMethod, body: [String: AnyObject]?, headers: HTTPHeaders? = nil) -> AnyPublisher<(response: T, statusCode: Int), Error> {
        
        return Future<(response: T, statusCode: Int), Error> { promise in
            let request = AF.request(url,
                                     method: method,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
                .responseDecodable(of: T.self)
            { response in
                self.removeTask(for: url)
                switch response.result {
                case .success(let value):
                    promise(.success((value, response.response?.statusCode ?? -1)))
                case .failure(let error):
                    Log.d(error)
                    promise(.failure(error))
                }
            }
            DispatchQueue.global().sync {
                self.ongoingTasks.append(TaskInfo(url: url, request: request))
            }
        }
        .eraseToAnyPublisher()
        
    }
    
    func removeTask(for url: String) {
        DispatchQueue.global().sync {
            if let index = ongoingTasks.firstIndex(where: { $0.url == url }) {
                let task = ongoingTasks[index]
                task.request.cancel()
                ongoingTasks.remove(at: index)
            }
        }
    }

    func encodeObjectToDictionary<T: Encodable>(_ object: T?) -> AnyPublisher<[String: AnyObject], Error> {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] ?? [:]
            return Just(json)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.invalidRequest)
                .eraseToAnyPublisher()
        }
    }
    
}



