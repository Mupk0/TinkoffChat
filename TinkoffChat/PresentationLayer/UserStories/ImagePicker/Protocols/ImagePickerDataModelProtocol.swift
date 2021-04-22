//
//  ImagePickerDataModelProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import UIKit

protocol ImagePickerDataModelProtocol {
    func getImages() -> [Images]
    
    func fetchImagesURL()
    func fetchImage(imageUrl: String, completion: @escaping (UIImage?) -> Void)
}
