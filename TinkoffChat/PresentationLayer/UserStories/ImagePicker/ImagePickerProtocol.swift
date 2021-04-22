//
//  ImagePickerProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.04.2021.
//

import UIKit

protocol ImagePickerProtocol {
    var presentationController: UIViewController? { get set }
    var delegate: ImagePickerDelegate? { get set }
    
    var imagePickerController: ImagePickerViewController? { get set }
    
    func present()
}
