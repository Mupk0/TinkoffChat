//
//  ProfileEditButton.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 07.03.2021.
//

import UIKit

class ProfileEditButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        setTitle("Edit", for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        setTitleColor(.systemBlue, for: .normal)
        layer.cornerRadius = 14
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
