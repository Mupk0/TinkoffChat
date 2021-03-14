//
//  UIViewController+Alerts.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.03.2021.
//

import UIKit

extension UIViewController {
    func showAlertWithTitle(title: String? = nil,
                            message: String? = nil,
                            buttonLeftTitle: String,
                            buttonRightTitle: String? = nil,
                            buttonLeftAction: @escaping (UIAlertAction) -> Void,
                            buttonRightAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonLeftTitle,
                                      style: .cancel,
                                      handler: buttonLeftAction))
        
        if buttonRightTitle != nil {
            alert.addAction(UIAlertAction(title: buttonRightTitle,
                                          style: .default,
                                          handler: buttonRightAction))
        }
        
        present(alert, animated: true)
    }
}
