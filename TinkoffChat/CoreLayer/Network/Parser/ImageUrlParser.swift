//
//  ImageUrlParser.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import Foundation

class ImageUrlParser: ParserProtocol {
    typealias Model = [Images]

    func parse(data: Data) -> [Images]? {
        do {
            let images = try JSONDecoder().decode(ImageData.self, from: data).hits
            return images
        } catch {
            print(error)
            return nil
        }
    }
}
