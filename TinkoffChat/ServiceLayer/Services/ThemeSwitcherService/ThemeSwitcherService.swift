//
//  ThemeSwitcherService.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import UIKit

class ThemeSwitcherService: ThemeSwitcherServiceProtocol {
    
    private let selectedThemeKey = "SelectedTheme"
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    public func apply(_ themeType: ThemeType) {
        // updateAppearances
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
        
        let messageViewAppearance = MessageView.appearance()
        messageViewAppearance.backgroundColor = themeType.navigationBackgroundColor
        
        // Reset Subviews
        UIApplication.shared.delegate?.window??.subviews.forEach({ (view: UIView) in
            view.removeFromSuperview()
            UIApplication.shared.delegate?.window??.addSubview(view)
        })
    }
    
    public func save(theme: ThemeType) {
        dataManager.save(theme, to: selectedThemeKey) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func load(completionHandler: @escaping (ThemeType?) -> Void) {
        dataManager.load(ThemeType.self, from: selectedThemeKey) { theme, _ in
            if let theme = theme {
                completionHandler(theme)
            } else {
                completionHandler(nil)
            }
        }
    }
}
