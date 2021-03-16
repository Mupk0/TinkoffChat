//
//  UIViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.03.2021.
//

import UIKit

extension UIViewController {
    
    var visibleVC: UIViewController? {
        get {
            return UIApplication.shared.keyWindow?.visibleViewController
        }
    }
    
    @objc func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
