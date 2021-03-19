//
//  IncomingMessageTableViewCell.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 01.03.2021.
//

import UIKit

class IncomingMessageTableViewCell: UITableViewCell, MessageCellProtocol {
    
    static let reuseIdentifier = "IncomingMessageTableViewCell"
    
    private let messageContainerView = IncomingMessageImageView()
    private let messageTextView = MessageTextView()

    func setMessageModel(_ model: MessageCellConfiguration) {
        messageTextView.text = model.text ?? "Unknown Message"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubview(messageContainerView)
        addSubview(messageTextView)

        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageContainerView.translatesAutoresizingMaskIntoConstraints = false

         NSLayoutConstraint.activate([
            messageTextView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            messageTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            messageTextView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor,
                                                   constant: -0.25 * frame.width),
            
            messageContainerView.topAnchor.constraint(equalTo: messageTextView.topAnchor),
            messageContainerView.bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor),
            messageContainerView.leadingAnchor.constraint(equalTo: messageTextView.leadingAnchor),
            messageContainerView.trailingAnchor.constraint(equalTo: messageTextView.trailingAnchor)
         ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        messageTextView.text = nil
    }
}
