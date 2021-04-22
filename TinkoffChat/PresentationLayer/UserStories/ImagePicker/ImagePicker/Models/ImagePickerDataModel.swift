//
//  ImagePickerDataModel.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import UIKit

protocol ImagePickerDataModelDelegate: class {
    func loadStarted()
    func loadComplited()
}

class ImagePickerDataModel: ImagePickerDataModelProtocol {
    private let networkService: NetworkServiceProtocol
    private let imageCacheService: ImageCacheServiceProtocol
    
    init(networkService: NetworkServiceProtocol,
         imageCacheService: ImageCacheServiceProtocol) {
        
        self.networkService = networkService
        self.imageCacheService = imageCacheService
    }
    
    weak var delegate: ImagePickerDataModelDelegate?
    
    private var pageNumber = 0
    private var images: [Images] = []
    
    public func getImages() -> [Images] {
        return images
    }
    
    func fetchImagesURL() {
        
        delegate?.loadStarted()
        
        pageNumber += 1
        
        networkService.getImageUrls(pageNumber: pageNumber) { images, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let images = images else { return }
            self.images.append(contentsOf: images)
            
            self.delegate?.loadComplited()
        }
    }
    
    func fetchImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        let finalImage = imageCacheService.checkCache(url: imageUrl)
        
        guard let image = finalImage else {
            self.networkService.getImage(imageUrl: imageUrl) { loadingImage, error in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let imageWeb = loadingImage else { return }
                self.imageCacheService.saveToCache(url: imageUrl, image: imageWeb)
                
                completion(imageWeb)
                
            }
            return
        }
        completion(image)
    }
}
