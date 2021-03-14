//
//  CustomButton.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 07.03.2021.
//

import UIKit

class CustomButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        setTitleColor(.systemBlue, for: .normal)
        setTitleColor(.lightGray, for: .disabled)
        layer.cornerRadius = 14
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
