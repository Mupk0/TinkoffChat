//
//  ImageUrlRequest.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import Foundation

class ImageUrlRequest: RequestProtocol {
    func urlRequest(pageNumber: Int?) -> URLRequest? {
        guard let pageNumber = pageNumber,
              let url = urlConstructor(pageNumber: pageNumber) else { return nil }
        return URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad)
    }
    
    private func urlConstructor(pageNumber: Int) -> URL? {
        var urlConstructor = URLComponents()
        
        urlConstructor.scheme = "https"
        urlConstructor.host = "pixabay.com"
        urlConstructor.path = "/api"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "key", value: "21276680-ed9fafe5fe650d225c143f29f"),
            URLQueryItem(name: "q", value: "yellow+flowers"),
            URLQueryItem(name: "image_type", value: "photo"),
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "per_page", value: "30")
        ]
        
        return urlConstructor.url
    }
}
