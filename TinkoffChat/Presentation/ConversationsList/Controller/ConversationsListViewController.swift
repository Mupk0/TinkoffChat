//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 28.02.2021.
//

import UIKit
import FirebaseFirestore
import CoreData

class ConversationsListViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let coreDataStack = CoreDataStack.shared
    
    private lazy var fetchRequestController: NSFetchedResultsControllerDelegate = {
        return ConversationsListFetchedResultsControllerDelegate(tableView: tableView)
    }()
    
    private lazy var tableViewManager: ConversationListTableManagerProtocol = {
        let fetchedResultsController = coreDataStack.getFetchedResultController()
        fetchedResultsController.delegate = fetchRequestController
        let tableManager = ConversationListTableManager(fetchedResultsController: fetchedResultsController)
        tableManager.delegate = self
        return tableManager
    }()
    
    private let networkService: NetworkService
    private weak var channelUpdateListener: ListenerRegistration?
    
    init() {
        self.networkService = NetworkService.shared
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureNetworkService()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        channelUpdateListener?.remove()
    }
    
    private func configureViews() {
        navigationItem.title = "Channels"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let profileButton = UIBarButtonItem(image: #imageLiteral(resourceName: "profileIcon"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(didTapProfileButton))
        navigationItem.rightBarButtonItem = profileButton
        
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapSettingsButton))
        let addChannelButton = UIBarButtonItem(title: "+",
                                               style: .plain,
                                               target: self,
                                               action: #selector(didTapAddChannelButton))
        navigationItem.leftBarButtonItems = [settingsButton, addChannelButton]
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.delegate = tableViewManager
        tableView.dataSource = tableViewManager
        
        tableView.register(ConversationsListTableViewCell.self,
                           forCellReuseIdentifier: ConversationsListTableViewCell.reuseIdentifier)
    }
    
    @objc private func didTapProfileButton() {
        let profileController = ProfileViewController()
        let navController = UINavigationController(rootViewController: profileController)
        present(navController, animated: true)
    }
    
    @objc private func didTapSettingsButton() {
        let themesViewController = ThemesViewController()
        navigationController?.pushViewController(themesViewController, animated: true)
        
        themesViewController.didSelectThemeType = { themeType in
            print("Selected \(themeType.rawValue) Theme")
        }
    }
    
    @objc private func didTapAddChannelButton() {
        let alertController = UIAlertController(title: "Введите название канала",
                                   message: nil,
                                   preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification,
                                                   object: textField,
                                                   queue: OperationQueue.main) { _ in
                alertController.actions.first?.isEnabled = !(textField.text?.isBlank ?? false)
            }
        })
        let textField = alertController.textFields?[0]
        textField?.textColor = .black

        let submitAction = UIAlertAction(title: "Создать", style: .default) { [weak self] _ in
            if let textField = textField, let channelName = textField.text {
                self?.networkService.addChannel(channelName: channelName)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена",
                                         style: .cancel,
                                         handler: { _ in })
        submitAction.isEnabled = false

        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    private func configureNetworkService() {
        let savedChannels = tableViewManager.getConversations()
        channelUpdateListener = networkService.getChannelUpdateListener(completion: { [weak self] channels in
            self?.coreDataStack.performSave { context in
                for channel in channels {
                    if savedChannels.contains(where: { $0.identifier == channel.identifier }) {
                        let savedChannel = self?.coreDataStack.getChannel(for: channel.identifier, with: context)
                        savedChannel?.setValue(channel.lastMessage, forKey: "lastMessage")
                        savedChannel?.setValue(channel.lastActivity, forKey: "lastActivity")
                    } else {
                        let newChannel = ChannelDb(context: context)
                        newChannel.identifier = channel.identifier
                        newChannel.name = channel.name
                        newChannel.lastMessage = channel.lastMessage
                        newChannel.lastActivity = channel.lastActivity
                    }
                }
            }
            self?.coreDataStack.performDelete { context in
                for channel in savedChannels {
                    if !channels.contains(where: { $0.identifier == channel.identifier }) {
                        context.delete(channel)
                    }
                }
            }
        })
    }
}

extension ConversationsListViewController: ConversationListTableManagerDelegate {
    func didSelectChannel(_ channel: SelectedChannelProtocol) {
        let chatViewController = ConversationViewController(userName: channel.name,
                                                            channelId: channel.id)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}
