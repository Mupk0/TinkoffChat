//
//  IncomingMessageImageView.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 07.03.2021.
//

import UIKit

class IncomingMessageImageView: UIImageView {
    
    @objc dynamic var messageBackgroundColor: UIColor? = UIColor(red: 0.875,
                                                                 green: 0.875,
                                                                 blue: 0.875,
                                                                 alpha: 1) {
        didSet {
            tintColor = messageBackgroundColor
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        let bubbleImage = #imageLiteral(resourceName: "incomingMessageBubble")
            .resizableImage(withCapInsets: UIEdgeInsets.BUBBLE_IMAGE_INSETS,
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
        image = bubbleImage
        tintColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
