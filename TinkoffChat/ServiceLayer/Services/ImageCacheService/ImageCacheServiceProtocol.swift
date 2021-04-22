//
//  ImageCacheServiceProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import UIKit

protocol ImageCacheServiceProtocol {
    func checkCache(url: String) -> UIImage?
    func saveToCache(url: String, image: UIImage)
}
