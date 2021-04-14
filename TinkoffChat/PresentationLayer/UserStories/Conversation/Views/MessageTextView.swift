//
//  MessageTextView.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 07.03.2021.
//

import UIKit

class MessageTextView: UITextView {
    
    @objc dynamic var messageTextColor: UIColor? = .black {
        didSet {
            textColor = messageTextColor
        }
    }
    
    init() {
        super.init(frame: .zero, textContainer: .none)
        
        textContainerInset = Constants.BUBBLE_IMAGE_INSETS
        backgroundColor = .clear
        font = UIFont.systemFont(ofSize: 16, weight: .light)
        sizeToFit()
        isScrollEnabled = false
        isEditable = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
