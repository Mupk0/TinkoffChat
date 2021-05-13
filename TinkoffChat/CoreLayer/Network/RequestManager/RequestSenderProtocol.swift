//
//  RequestSenderProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import Foundation

protocol RequestSenderProtocol {
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completionHandler: @escaping(Result<Parser.Model, ApiError>) -> Void)
}
