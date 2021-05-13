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
        let apiUrl = privateConfig.getValueForProperties(.apiUrl)
        let apiToken = privateConfig.getValueForProperties(.apiToken)
        var urlConstructor = URLComponents(string: apiUrl)
        
        urlConstructor?.queryItems = [
            URLQueryItem(name: "key", value: apiToken),
            URLQueryItem(name: "q", value: "yellow+flowers"),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "per_page", value: "30")
        ]
        
        return urlConstructor?.url
    }
}
