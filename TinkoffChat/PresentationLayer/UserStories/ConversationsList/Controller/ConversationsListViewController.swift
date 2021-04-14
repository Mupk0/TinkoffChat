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
    
    private let presentationAssembly: PresentationAssemblyProtocol
    private let dataModel: ConversationsListDataModelProtocol
    
    private lazy var fetchRequestController: NSFetchedResultsControllerDelegate = {
        return FetchedResultsControllerDelegate(tableView: tableView)
    }()
    
    private lazy var tableViewManager: ConversationListTableManagerProtocol = {
        let fetchedResultsController = dataModel.getFetchedRequestController()
        fetchedResultsController.delegate = fetchRequestController
        let tableManager = ConversationListTableManager(fetchedResultsController: fetchedResultsController)
        tableManager.delegate = self
        
        return tableManager
    }()
    
    init(presentationAssembly: PresentationAssemblyProtocol,
         dataModel: ConversationsListDataModelProtocol) {
        
        self.presentationAssembly = presentationAssembly
        self.dataModel = dataModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureNavigationBar()
        loadData()
    }
    
    private func configureNavigationBar() {
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
    }
    
    private func configureViews() {
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
    
    private func loadData() {
        dataModel.fetchChannels()
    }
    
    @objc private func didTapProfileButton() {
        let profileController = presentationAssembly.profileViewController()
        let navController = UINavigationController(rootViewController: profileController)
        present(navController, animated: true)
    }
    
    @objc private func didTapSettingsButton() {
        let themesViewController = presentationAssembly.themeListViewController()
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
                self?.dataModel.createNewChannel(name: channelName)
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
}

extension ConversationsListViewController: ConversationListTableManagerDelegate {
    func didRemoveChannel(_ channel: ChannelDb) {
        dataModel.removeChannel(channel: channel)
    }
    
    func didSelectChannel(_ channel: SelectedChannelProtocol) {
        let chatViewController = presentationAssembly.conversationViewController(channel: channel)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}
