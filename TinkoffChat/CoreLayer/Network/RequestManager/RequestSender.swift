//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import Foundation

class RequestSender: RequestSenderProtocol {
    
    public func send<Parser>(pageNumber: Int?,
                             requestConfig config: RequestConfig<Parser>,
                             completionHandler: @escaping (Result<Parser.Model, ApiError>) -> Void) where Parser: ParserProtocol {
        
        let session = getSession()
        guard let urlRequest = config.request.urlRequest(pageNumber: pageNumber) else {
            completionHandler(.failure(.stringParseError))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.failure(.taskError))
                return
            }
            
            guard let data = data,
                  let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                completionHandler(.failure(.dataParseError))
                return
            }
            
            completionHandler(Result.success(parsedModel))
        }
        task.resume()
    }
    
    private func getSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        return session
    }
}
