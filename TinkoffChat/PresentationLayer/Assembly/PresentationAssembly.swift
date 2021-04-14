//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

class PresentationAssembly: PresentationAssemblyProtocol {
    
    private let serviceAssembly: ServicesAssemblyProtocol
    
    init(serviceAssembly: ServicesAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    // MARK: - ConversationsListViewController
    func conversationsListViewController() -> ConversationsListViewController {
        let dataModel = ConversationsListDataModel(firebaseService: serviceAssembly.firebaseService,
                                                   coreDataService: serviceAssembly.coreDataManager)
        let viewController = ConversationsListViewController(presentationAssembly: self,
                                                             dataModel: dataModel)
        return viewController
    }
    
    // MARK: - ConversationViewController
    func conversationViewController(channel: SelectedChannelProtocol) -> ConversationViewController {
        let dataModel = ConversationDataModel(firebaseService: serviceAssembly.firebaseService,
                                              coreDataService: serviceAssembly.coreDataManager,
                                              settingsService: serviceAssembly.settingsService)
        let viewController = ConversationViewController(channel: channel, dataModel: dataModel)
        return viewController
    }
    
    // MARK: - ProfileViewController
    func profileViewController() -> ProfileViewController {
        let viewController = ProfileViewController()
        return viewController
    }
    
    // MARK: - ThemesViewController
    func themeListViewController() -> ThemesViewController {
        let dataModel = ThemesDataModel(themeSwitchService: serviceAssembly.themeSwitcherService,
                                        settingsService: serviceAssembly.settingsService)
        return ThemesViewController(dataModel: dataModel)
    }
    
}
