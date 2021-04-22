//
//  ImageCacheService.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import UIKit

class ImageCacheService: ImageCacheServiceProtocol {
    private var imageCache = NSCache<NSString, UIImage>()
    
    func checkCache(url: String) -> UIImage? {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            return cachedImage
        }
        return nil
    }
    
    func saveToCache(url: String, image: UIImage) {
        imageCache.setObject(image, forKey: url as NSString)
    }
}
