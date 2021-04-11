//
//  ConversationsListTableViewCell.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 01.03.2021.
//

import UIKit

class ConversationsListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ConversationsListTableViewCell"
    
    private let userNameLabel: MainTitleLabel = {
        let label = MainTitleLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    private let userStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    private let lastMessageLabel: SubTitleLabel = {
        let label = SubTitleLabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let lastMessageDateLabel: SubTitleLabel = {
        let label = SubTitleLabel()
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
        addSubview(userStatusView)
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageDateLabel.translatesAutoresizingMaskIntoConstraints = false
        userStatusView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: lastMessageDateLabel.leadingAnchor, constant: -22),
            
            lastMessageDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            lastMessageDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            lastMessageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            lastMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            lastMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            lastMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
            
            userStatusView.heightAnchor.constraint(equalToConstant: 12),
            userStatusView.widthAnchor.constraint(equalToConstant: 12),
            userStatusView.topAnchor.constraint(equalTo: userNameLabel.topAnchor),
            userStatusView.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 10)
        ])
        
        userNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        userNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        userNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        lastMessageLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        lastMessageLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        lastMessageDateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        userStatusView.layer.cornerRadius = 6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: ConversationCellConfiguration) {
        userNameLabel.text = model.name
        lastMessageDateLabel.text = getStringFromDate(model.lastActivity)
        lastMessageLabel.text = model.lastMessage ?? "No messages yet"
        
        lastMessageLabel.font = model.lastMessage != nil
            ? UIFont.systemFont(ofSize: 13,
                                weight: .light)
            : UIFont(name: "HelveticaNeue-Thin", size: 13.0)
        
        userStatusView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userNameLabel.text = nil
        lastMessageDateLabel.text = nil
        lastMessageLabel.text = nil
        lastMessageLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
    }
    
    private func getOfflineBackgroundColor() -> UIColor {
        let theme = ThemeType(Settings.shared.themeType)
        return theme.mainBackgroundColor
    }
    
    private func getStringFromDate(_ date: Date?) -> String {
        if let date = date {
            let calendar = Calendar.current
            let dateFormatter = DateFormatter()
            let startOfCurrentDay = calendar.startOfDay(for: Date())
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = date > startOfCurrentDay ? "HH:mm" : "dd MMM"
            
            return dateFormatter.string(from: date)
        }
        return "Unknown Date"
    }
}
