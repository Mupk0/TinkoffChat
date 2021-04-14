//
//  OutgoingMessageImageView.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 07.03.2021.
//

import UIKit

class OutgoingMessageImageView: UIImageView {
    
    @objc dynamic var messageBackgroundColor: UIColor? = UIColor(red: 0.863,
                                                                 green: 0.969,
                                                                 blue: 0.773,
                                                                 alpha: 1) {
        didSet {
            tintColor = messageBackgroundColor
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        let bubbleImage = #imageLiteral(resourceName: "outgoingMessageBubble")
            .resizableImage(withCapInsets: Constants.BUBBLE_IMAGE_INSETS,
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
        image = bubbleImage
        tintColor = UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
