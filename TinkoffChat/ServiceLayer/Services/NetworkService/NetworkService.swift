//
//  NetworkService.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import UIKit

class NetworkService: NetworkServiceProtocol {
    
    private let requestSender: RequestSenderProtocol
    private let privateConfig: PrivateConfigProtocol
    
    init(requestSender: RequestSenderProtocol,
         privateConfig: PrivateConfigProtocol) {
        
        self.requestSender = requestSender
        self.privateConfig = privateConfig
    }
    
    public func getImageUrls(pageNumber: Int,
                             completionHandler: @escaping ([Images]?, String?) -> Void) {
        let requestConfig = RequestsFactory.Requests.newImageUrlConfig(pageNumber: pageNumber,
                                                                       privateConfig: privateConfig)
        
        loadImageUrl(requestConfig: requestConfig,
                     completionHandler: completionHandler)
    }
    
    public func getImage(imageUrl: String,
                         completionHandler: @escaping (UIImage?, String?) -> Void) {
        let requestConfig = RequestsFactory.Requests.newImageConfig(imageUrl: imageUrl)
        
        loadImage(requestConfig: requestConfig, completionHandler: completionHandler)
    }
    
    private func loadImageUrl(requestConfig: RequestConfig<ImageUrlParser>,
                              completionHandler: @escaping ([Images]?, String?) -> Void) {
        requestSender.send(requestConfig: requestConfig) { (result: Result<[Images], ApiError>) in
            
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
        requestSender.send(requestConfig: requestConfig) { (result: Result<UIImage, ApiError>) in
            
            switch result {
            case .success(let apps):
                completionHandler(apps, nil)
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
}
