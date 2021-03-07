//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 28.02.2021.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)

    var conversations: [ConversationCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        conversations = getData()
    }
    
    private func configureViews() {
        
        navigationItem.title = "Tinkoff Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let profileButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "profileIcon"),
                                                 style: .plain,
                                                 target: self, action: #selector(didTapProfileButton))
        navigationItem.rightBarButtonItem = profileButton
        
        let settingsButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "settings"),
                                                 style: .plain,
                                                 target: self, action: #selector(didTapSettingsButton))
        navigationItem.leftBarButtonItem = settingsButton
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        themesViewController.delegate = self
        navigationController?.pushViewController(themesViewController, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ConversationsListType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ConversationsListType.init(rawValue: section)?.getTitle()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isOnlineSection = ConversationsListType.init(rawValue: section) == .online
        return isOnlineSection ? conversations.getOnline().count : conversations.getOffline().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isOnlineSection = ConversationsListType.init(rawValue: indexPath.section) == .online
        let conversation = isOnlineSection ? conversations.getOnline()[indexPath.row] : conversations.getOffline()[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsListTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? ConversationsListTableViewCell else {
            fatalError("dequeueReusableCell ConversationsListTableViewCell not found")
        }
        cell.configureCell(model: conversation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isOnlineSection = ConversationsListType.init(rawValue: indexPath.section) == .online
        let conversation = isOnlineSection ? conversations.getOnline()[indexPath.row] : conversations.getOffline()[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let chatViewController =  ConversationViewController(userName: conversation.name ?? "Unknown Name")
        navigationController?.pushViewController(chatViewController, animated: true)
    }

}


extension ConversationsListViewController: ThemesViewControllerDelegate {
    func didSelectTheme(_ themeType: ThemeType) {
        print("Selected \(themeType.rawValue) Theme")
    }
}

extension ConversationsListViewController {
    fileprivate func getData() -> [ConversationCellModel] {
        var result: [ConversationCellModel] = []
        for (_, index) in (0 ... 30).enumerated() {
            let element = ConversationCellModel(name: Randomizer.shared.getName(),
                                                message: Randomizer.shared.getText(),
                                                date: Randomizer.shared.getDate(),
                                                online: index < 15 ? true : false,
                                                hasUnreadMessages: Bool.random())
            result.append(element)
        }
        
        return result
    }
}
