//
//  PresentationAssemblyProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

protocol PresentationAssemblyProtocol {
    func conversationsListViewController() -> ConversationsListViewController
    func conversationViewController(channel: SelectedChannelProtocol) -> ConversationViewController
    func profileViewController() -> ProfileViewController
    func themeListViewController() -> ThemesViewController
    func imagePicker() -> ImagePicker
}
