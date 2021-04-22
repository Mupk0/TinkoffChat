//
//  NetworkServiceProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import UIKit

protocol NetworkServiceProtocol {
    func getImageUrls(pageNumber: Int?,
                      completionHandler: @escaping ([Images]?, String?) -> Void)
    func getImage(imageUrl: String,
                  completionHandler: @escaping (UIImage?, String?) -> Void)
}
