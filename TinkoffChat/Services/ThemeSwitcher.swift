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
        updateUserDefaultsWith(themeType)
    }
    
    private func updateAppereances(_ themeType: ThemeType) {
        // Tables
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = themeType.mainBackgroundColor
        // Chat Cells
        let incomingMessageCellAppearance = IncomingMessageImageView.appearance()
        incomingMessageCellAppearance.messageBackgroundColor = themeType.incomingMessageBackgroundColor
        
        let outgoingMessageCellAppearance = OutgoingMessageImageView.appearance()
        outgoingMessageCellAppearance.messageBackgroundColor = themeType.outgoingMessageBackgroundColor
        
        let messageTextViewAppearence = MessageTextView.appearance()
        messageTextViewAppearence.messageTextColor = themeType.mainTitleLabelColor
        // Navigation
        UINavigationBar.appearance().barStyle = themeType.barStyle
        UINavigationBar.appearance().tintColor = themeType.mainTitleLabelColor
        UINavigationBar.appearance().barTintColor = themeType.navigationBackgroundColor
        UINavigationBar.appearance().shadowImage = themeType.navigationSeparatorColor.getOnePxImage()
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: themeType.mainTitleLabelColor as Any]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: themeType.mainTitleLabelColor as Any]
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: themeType.mainTitleLabelColor as Any],
                                                            for: .normal)
        // Buttons
        let customButtonAppearance = CustomButton.appearance()
        customButtonAppearance.backgroundColor = themeType.buttonBackgroundColor
        // Labels
        let mainLabelAppearance = MainTitleLabel.appearance()
        mainLabelAppearance.textColor = themeType.mainTitleLabelColor
        
        let subTitleLabelAppearance = SubTitleLabel.appearance()
        subTitleLabelAppearance.textColor = themeType.subtitleLabelColor
        
        let backgroundViewAppearance = MainBackgroundView.appearance()
        backgroundViewAppearance.backgroundColor = themeType.mainBackgroundColor
        
        let chatListCellAppearance = ConversationsListTableViewCell.appearance()
        chatListCellAppearance.backgroundColor = themeType.mainBackgroundColor
        
        let themeBackgroundViewAppearance = ThemeControllerBackgroundView.appearance()
        themeBackgroundViewAppearance.backgroundColor = themeType.themeControllerBackgroundColor
        
        let textFieldAppearance = UITextField.appearance()
        textFieldAppearance.textColor = themeType.mainTitleLabelColor
        
        let textViewAppearance = UITextView.appearance()
        textViewAppearance.textColor = themeType.mainTitleLabelColor
        textViewAppearance.backgroundColor = themeType.mainBackgroundColor
        
        let activityIndicatorAppearance = UIActivityIndicatorView.appearance()
        activityIndicatorAppearance.color = themeType.mainTitleLabelColor
    }
    
    private func resetSubviews() {
        // Reset Appearances
        UIApplication.shared.delegate?.window??.subviews.forEach({ (view: UIView) in
          view.removeFromSuperview()
            UIApplication.shared.delegate?.window??.addSubview(view)
        })
    }
    
    private func updateUserDefaultsWith(_ themeType: ThemeType) {
        let settings = Settings.shared
        settings.themeType = themeType.rawValue
        settings.save()
    }
}
