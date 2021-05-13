//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import Foundation

class RequestSender: RequestSenderProtocol {
    
    private let backgroundQueue = DispatchQueue(label: "ru.tinkoff.TinkoffChat.RequestSender",
                                                qos: .userInitiated)
    
    public func send<Parser>(requestConfig config: RequestConfig<Parser>,
                             completionHandler: @escaping (Result<Parser.Model, ApiError>) -> Void) where Parser: ParserProtocol {
        
        backgroundQueue.async {
            let session = self.getSession()
            let urlRequest = config.request.urlRequest()
            
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
    }
    
    private func getSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        return session
    }
}
