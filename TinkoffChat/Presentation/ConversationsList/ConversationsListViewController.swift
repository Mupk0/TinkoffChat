//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 28.02.2021.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    var conversationsOnline: [ConversationCellModel] = []
    var conversationsHistory: [ConversationCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        loadData()
    }
    
    private func loadData() {
        for item in getData() {
            if item.online {
                conversationsOnline.append(item)
            } else {
                conversationsHistory.append(item)
            }
        }
    }
    
    private func configureViews() {
        
        navigationItem.title =  "Tinkoff Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let profileButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "profileIcon"),
                                                 style: .plain,
                                                 target: self, action: #selector(didTapProfileButton))
        navigationItem.rightBarButtonItem = profileButton
        
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
        return section == 0 ? conversationsOnline.count : conversationsHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = indexPath.section == 0 ? conversationsOnline[indexPath.row] : conversationsHistory[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsListTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? ConversationsListTableViewCell else {
            fatalError("dequeueReusableCell ConversationsListTableViewCell not found")
        }
        cell.configureCell(model: conversation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let chatViewController =  ConversationViewController()
        navigationController?.pushViewController(chatViewController, animated: true)
    }

}

extension ConversationsListViewController {
    fileprivate func getData() -> [ConversationCellModel] {
        var result: [ConversationCellModel] = []
        for (_, index) in (0 ... 20).enumerated() {
            let element = ConversationCellModel(name: Randomizer.shared.getName(),
                                                message: Randomizer.shared.getText(),
                                                date: Randomizer.shared.getDate(),
                                                online: index < 10 ? true : false,
                                                hasUnreadMessages: Bool.random())
            result.append(element)
        }
        return result
    }
}
