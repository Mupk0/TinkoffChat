//
//  NetworkService.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import UIKit

class NetworkService: NetworkServiceProtocol {
    private let requestSender: RequestSenderProtocol
    
    init(requestSender: RequestSenderProtocol) {
        self.requestSender = requestSender
    }
    
    public func getImageUrls(pageNumber: Int?,
                             completionHandler: @escaping ([Images]?, String?) -> Void) {
        let requestConfig = RequestsFactory.Requests.newImageUrlConfig()
        
        loadImageUrl(pageNumber: pageNumber,
                     requestConfig: requestConfig,
                     completionHandler: completionHandler)
    }
    
    public func getImage(imageUrl: String,
                         completionHandler: @escaping (UIImage?, String?) -> Void) {
        let requestConfig = RequestsFactory.Requests.newImageConfig(imageUrl: imageUrl)
        
        loadImage(requestConfig: requestConfig, completionHandler: completionHandler)
    }
    
    private func loadImageUrl(pageNumber: Int?,
                              requestConfig: RequestConfig<ImageUrlParser>,
                              completionHandler: @escaping ([Images]?, String?) -> Void) {
        requestSender.send(pageNumber: pageNumber,
                           requestConfig: requestConfig) { (result: Result<[Images], ApiError>) in
            
            switch result {
            case .success(let apps):
                completionHandler(apps, nil)
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
    
    private func loadImage(requestConfig: RequestConfig<ImageParser>,
                           completionHandler: @escaping (UIImage?, String?) -> Void) {
        requestSender.send(pageNumber: nil,
                           requestConfig: requestConfig) { (result: Result<UIImage, ApiError>) in
            
            switch result {
            case .success(let apps):
                completionHandler(apps, nil)
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
}
