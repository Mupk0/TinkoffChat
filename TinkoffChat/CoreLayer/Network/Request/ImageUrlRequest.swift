//
//  ImageUrlRequest.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import Foundation

class ImageUrlRequest: RequestProtocol, RequestPaginationProtocol {
    
    var pageNumber: Int
    
    private let environment: EnvironmentProtocol
    
    init(pageNumber: Int,
         environment: EnvironmentProtocol) {
        
        self.pageNumber = pageNumber
        self.environment = environment
    }
    
    func urlRequest() -> URLRequest {
        let url = urlConstructor(pageNumber: pageNumber)
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    }
    
    private func urlConstructor(pageNumber: Int) -> URL {
        let apiUrl = environment.getValueForProperties(.apiUrl)
        let apiToken = environment.getValueForProperties(.apiToken)
        guard var urlConstructor = URLComponents(string: apiUrl) else {
            fatalError("API Url Sintaxis Error")
        }
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "key", value: apiToken),
            URLQueryItem(name: "q", value: "yellow+flowers"),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "per_page", value: "30")
        ]
        
        guard let url = urlConstructor.url else {
            fatalError("URLComponents can't parse url")
        }
        
        return url
    }
}
