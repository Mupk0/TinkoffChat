//
//  ImageRequest.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import Foundation

class ImageRequest: RequestProtocol {
    var url: String
    
    init(url: String) {
        self.url = url
    }
    
    func urlRequest(pageNumber: Int?) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        return URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad)
    }
}
