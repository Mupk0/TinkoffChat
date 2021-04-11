//
//  ThemeTypeView.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 07.03.2021.
//

import UIKit

class ThemeTypeView: UIView {
    
    private let themeBackgroundView = UIView()
    
    private let themeNameLabel = UILabel()
    
    private let themeIncomingMessageView: UIImageView = {
        let imageView = UIImageView()
        let bubbleImage = #imageLiteral(resourceName: "incomingMessageBubble")
            .resizableImage(withCapInsets: Constants.BUBBLE_IMAGE_INSETS,
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
        imageView.image = bubbleImage
        return imageView
    }()
    
    private let themeOutgoingMessageView: UIImageView = {
        let imageView = UIImageView()
        let bubbleImage = #imageLiteral(resourceName: "outgoingMessageBubble")
            .resizableImage(withCapInsets: Constants.BUBBLE_IMAGE_INSETS,
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
        imageView.image = bubbleImage
        return imageView
    }()
    
    public var isSelected: Bool = false {
        didSet {
            isSelected ? addBorder() : removeBorder()
        }
    }
    
    public var didTapTheme: (() -> Void)?
    
    init(_ themeType: ThemeType) {
        super.init(frame: .zero)
        
        addSubview(themeBackgroundView)
        addSubview(themeNameLabel)
        themeBackgroundView.addSubview(themeIncomingMessageView)
        themeBackgroundView.addSubview(themeOutgoingMessageView)
        
        themeBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        themeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        themeIncomingMessageView.translatesAutoresizingMaskIntoConstraints = false
        themeOutgoingMessageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            themeBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            themeBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            themeBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            themeBackgroundView.heightAnchor.constraint(equalToConstant: 57),
            
            themeNameLabel.topAnchor.constraint(equalTo: themeBackgroundView.bottomAnchor, constant: 20),
            themeNameLabel.centerXAnchor.constraint(equalTo: themeBackgroundView.centerXAnchor),
            
            themeIncomingMessageView.topAnchor.constraint(equalTo: themeBackgroundView.topAnchor, constant: 14),
            themeIncomingMessageView.leadingAnchor.constraint(equalTo: themeBackgroundView.leadingAnchor, constant: 33),
            themeIncomingMessageView.bottomAnchor.constraint(equalTo: themeBackgroundView.bottomAnchor, constant: -18),
            themeIncomingMessageView.trailingAnchor.constraint(equalTo: themeBackgroundView.centerXAnchor, constant: -3),
            
            themeOutgoingMessageView.topAnchor.constraint(equalTo: themeBackgroundView.topAnchor, constant: 22),
            themeOutgoingMessageView.trailingAnchor.constraint(equalTo: themeBackgroundView.trailingAnchor, constant: -33),
            themeOutgoingMessageView.bottomAnchor.constraint(equalTo: themeBackgroundView.bottomAnchor, constant: -10),
            themeOutgoingMessageView.leadingAnchor.constraint(equalTo: themeBackgroundView.centerXAnchor, constant: 3)
        ])
        
        themeBackgroundView.backgroundColor = themeType.mainBackgroundColor
        themeBackgroundView.layer.cornerRadius = 15.5
        
        themeIncomingMessageView.tintColor = themeType.incomingMessageBackgroundColor
        themeOutgoingMessageView.tintColor = themeType.outgoingMessageBackgroundColor
        
        themeNameLabel.text = themeType.rawValue
        themeNameLabel.textColor = .white
        themeNameLabel.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(didSelectTheme)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didSelectTheme() {
        didTapTheme?()
    }
    
    private func addBorder() {
        themeBackgroundView.layer.borderWidth = 3
        themeBackgroundView.layer.borderColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1).cgColor
    }
    
    private func removeBorder() {
        themeBackgroundView.layer.borderWidth = 0
        themeBackgroundView.layer.borderColor = UIColor.clear.cgColor
    }
}
