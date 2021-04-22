//
//  ImagePicker.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 19.02.2021.
//

import UIKit

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

class ImagePicker: NSObject, ImagePickerProtocol {
    
    weak var presentationController: UIViewController?
    var imagePickerController: ImagePickerViewController?
    weak var delegate: ImagePickerDelegate?
    
    private func getAction(for type: UIImagePickerController.SourceType,
                           title: String) -> UIAlertAction? {
        
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { _ in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = type
            self.presentationController?.present(pickerController, animated: true)
        }
    }
    
    public func present() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        if let action = self.getAction(for: .camera,
                                       title: "Сделать фото") {
            alertController.addAction(action)
        }
        if let action = self.getAction(for: .photoLibrary,
                                       title: "Установить из галлереи") {
            alertController.addAction(action)
        }
        
        if let picker = imagePickerController {
            picker.delegate = delegate
            let navWithVC = UINavigationController(rootViewController: picker)
            alertController.addAction(UIAlertAction(title: "Загрузить",
                                                    style: .default,
                                                    handler: { _ in
                                                        self.presentationController?.present(navWithVC, animated: true)
                                                    }))
        }

        alertController.addAction(UIAlertAction(title: "Отменить",
                                                style: .cancel,
                                                handler: { _ in
            self.delegate?.didSelect(image: nil)
        }))
        alertController.clearConstraintErrors()
        presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController,
                                  didSelect image: UIImage?) {
        delegate?.didSelect(image: image)
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.editedImage] as? UIImage
        pickerController(picker, didSelect: image)
    }
}
