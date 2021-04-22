//
//  ImageParser.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import Foundation

import UIKit

class ImageParser: ParserProtocol {
    typealias Model = UIImage
    
    func parse(data: Data) -> Model? {
        guard let image = UIImage(data: data) else { return nil }
        return image
    }
}
