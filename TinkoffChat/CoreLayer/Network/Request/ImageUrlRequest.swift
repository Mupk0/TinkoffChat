//
//  ImageUrlRequest.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import Foundation

class ImageUrlRequest: RequestProtocol {
    
    private let privateConfig: PrivateConfigProtocol
    
    init(privateConfig: PrivateConfigProtocol) {
        self.privateConfig = privateConfig
    }
    
    func urlRequest(pageNumber: Int?) -> URLRequest? {
        guard let pageNumber = pageNumber,
              let url = urlConstructor(pageNumber: pageNumber) else { return nil }
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    }
    
    private func urlConstructor(pageNumber: Int) -> URL? {
        var urlConstructor = URLComponents()
        
        guard let apiPath = privateConfig.getValueForProperties(.apiPath),
              let apiScheme = privateConfig.getValueForProperties(.apiScheme),
              let apiHost = privateConfig.getValueForProperties(.apiHost),
              let apiToken = privateConfig.getValueForProperties(.apiToken) else {
            fatalError("API params not found in Private Config")
        }
        
        urlConstructor.scheme = apiScheme
        urlConstructor.host = apiHost
        urlConstructor.path = apiPath
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "key", value: apiToken),
            URLQueryItem(name: "q", value: "yellow+flowers"),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "per_page", value: "30")
        ]
        
        return urlConstructor.url
    }
}
