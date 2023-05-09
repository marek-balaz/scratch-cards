//
//  O2API.swift
//  ScratchCards
//
//  Created by Marek Baláž on 08/05/2023.
//

import Foundation
import Alamofire
import Combine

class O2API {
    
    private static let baseUrl = Const.getStringFor(key: "O2API")
    
    static func headers() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        return headers
    }
    
    static func url(path: String, parameters: [String : String]) -> String {
        guard var urlComponents = URLComponents(string: baseUrl) else {
            fatalError("Invalid path for URL.")
        }
        urlComponents.path += "/" + path
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        Log.d(urlComponents.url!.absoluteString)
        return urlComponents.url!.absoluteString
    }
    
}



