//
//  ThemeSwitcher.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 06.03.2021.
//

import UIKit

class ThemeSwitcher {
    
    static var shared = ThemeSwitcher()
    
    public func setTheme(_ themeType: ThemeType) {
        updateAppereances(themeType)
        resetSubviews()
        updateUserTheme(themeType)
    }
    
    private func updateAppereances(_ themeType: ThemeType) {
        // Tables
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = themeType.backgroundColor
        // Chat Cells
        let incomingMessageCellAppearance = IncomingMessageImageView.appearance()
        incomingMessageCellAppearance.messageBackgroundColor = themeType.incomingMessageBackgroundColor
        
        let outgoingMessageCellAppearance = OutgoingMessageImageView.appearance()
        outgoingMessageCellAppearance.messageBackgroundColor = themeType.outgoingMessageBackgroundColor
        
        let messageTextViewAppearence = MessageTextView.appearance()
        messageTextViewAppearence.messageTextColor = themeType.textColor
        // Navigation
        UINavigationBar.appearance().barStyle = themeType.barStyle
        UINavigationBar.appearance().tintColor = themeType.textColor
        UINavigationBar.appearance().barTintColor = themeType.navigationBackgroundColor
        UINavigationBar.appearance().shadowImage = themeType.navigationSeparatorColor.getOnePxImage()
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: themeType.textColor as Any]
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: themeType.textColor as Any],
                                                            for: .normal)
        // Buttons
        let customButtonAppearance = ProfileEditButton.appearance()
        customButtonAppearance.backgroundColor = themeType.buttonBackground
        // Labels
        let mainLabelAppearance = MainTitleLabel.appearance()
        mainLabelAppearance.textColor = themeType.textColor
        
        let subTitleLabelAppearance = SubTitleLabel.appearance()
        subTitleLabelAppearance.textColor = themeType.subtitleLabelColor
        
        let backgroundViewAppearance = ThemeBackgroundView.appearance()
        backgroundViewAppearance.backgroundColor = themeType.backgroundColor
        
        let convCell = ConversationsListTableViewCell.appearance()
        convCell.backgroundColor = themeType.backgroundColor
    }
    
    private func resetSubviews() {
        // Reset Appearances
        UIApplication.shared.delegate?.window??.subviews.forEach({ (view: UIView) in
          view.removeFromSuperview()
            UIApplication.shared.delegate?.window??.addSubview(view)
        })
    }
    
    private func updateUserTheme(_ themeType: ThemeType) {
        let settings = Settings.shared
        settings.themeType = themeType.rawValue
        settings.save()
    }
}
