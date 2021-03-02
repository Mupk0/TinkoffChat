//
//  ConversationsListTableViewCell.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 01.03.2021.
//

import UIKit

class ConversationsListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ConversationsListTableViewCell"
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let lastMessageDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(userNameLabel)
        addSubview(lastMessageLabel)
        addSubview(lastMessageDateLabel)
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: lastMessageDateLabel.leadingAnchor, constant: -10),
            
            lastMessageDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            lastMessageDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            lastMessageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            lastMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            lastMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            lastMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
        ])
        
        userNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        userNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        lastMessageLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        lastMessageLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: ConversationCellConfiguration) {
        userNameLabel.text = model.name ?? "Unknown Name"
        lastMessageDateLabel.text = DateUtils.shared.getStringFromDate(model.date)
        lastMessageLabel.text = model.message ?? "No messages yet"
        
        lastMessageLabel.font = model.message != nil
            ? UIFont.systemFont(ofSize: 13,
                                weight: model.hasUnreadMessages ? .bold : .light)
            : UIFont(name: "HelveticaNeue-Thin", size: 13.0)
        
        
        backgroundColor = model.online ? UIColor(red: 1.00, green: 0.96, blue: 0.62, alpha: 1.00) : .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userNameLabel.text = nil
        lastMessageDateLabel.text = nil
        lastMessageLabel.text = nil
        backgroundColor = .white
        lastMessageLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
    }
}
