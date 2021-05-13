//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import Foundation

import UIKit

struct RequestsFactory {
    struct Requests {
        static func newImageUrlConfig(pageNumber: Int,
                                      environment: EnvironmentProtocol) -> RequestConfig<ImageUrlParser> {
            return RequestConfig<ImageUrlParser>(request: ImageUrlRequest(pageNumber: pageNumber,
                                                                          environment: environment),
                                                 parser: ImageUrlParser())
        }
        
        static func newImageConfig(imageUrl: String) -> RequestConfig<ImageParser> {
            let request = ImageRequest(url: imageUrl)
            return RequestConfig<ImageParser>(request: request,
                                              parser: ImageParser())
        }
    }
}
