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
        let dataModel = ProfileDataModel(profileService: serviceAssembly.profileService)
        let viewController = ProfileViewController(presentationAssembly: self,
                                                   dataModel: dataModel)
        return viewController
    }
    
    // MARK: - ThemesViewController
    func themeListViewController() -> ThemesViewController {
        let dataModel = ThemesDataModel(themeSwitchService: serviceAssembly.themeSwitcherService,
                                        settingsService: serviceAssembly.settingsService)
        return ThemesViewController(dataModel: dataModel)
    }
    
    // MARK: - Image Picker
    func imagePicker() -> ImagePickerViewController {
        let dataModel = ImagePickerDataModel(networkService: serviceAssembly.networkService,
                                             imageCacheService: serviceAssembly.imageCacheService)
        let collectionViewLayout = ImagePickerCollectionViewFlowLayout()
        let imagePicker = ImagePickerViewController(dataModel: dataModel,
                                                    collectionViewLayout: collectionViewLayout)
        dataModel.delegate = imagePicker
        return imagePicker
    }
}
