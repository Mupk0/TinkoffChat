//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 28.02.2021.
//

import UIKit
import FirebaseFirestore

class ConversationsListViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    var conversations: [Channel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        getData()
    }
    
    private func configureViews() {
        navigationItem.title = "Tinkoff Chat"
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
        navigationController?.pushViewController(themesViewController, animated: true)
        
        themesViewController.didSelectThemeType = { themeType in
            print("Selected \(themeType.rawValue) Theme")
        }
    }
    
    @objc private func didTapAddChannelButton() {
        let alertController = UIAlertController(title: "Введите название канала",
                                   message: nil,
                                   preferredStyle: .alert)
        alertController.addTextField()
        let textField = alertController.textFields?[0]
        textField?.textColor = .black

        let submitAction = UIAlertAction(title: "Создать", style: .default) { _ in
            if let textField = textField, let channelName = textField.text {
                self.addChannel(channelName: channelName)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена",
                                         style: .cancel,
                                         handler: { _ in })

        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Channels"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = conversations[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsListTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? ConversationsListTableViewCell else {
            fatalError("dequeueReusableCell ConversationsListTableViewCell not found")
        }
        cell.configureCell(model: conversation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = conversations[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let chatViewController = ConversationViewController(userName: conversation.name ?? "Unknown Name",
                                                            channelId: conversation.identifier)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
}

extension ConversationsListViewController {
    fileprivate func getData() {
        var result: [Channel] = []
        
        let db = Firestore.firestore()
        let reference = db.collection("channels")
        reference.addSnapshotListener { [weak self] snapshot, _ in
            if let documents = snapshot?.documents {
                for document in documents {
                    let doc = document.data()
                    if doc["name"] != nil {
                        let dateTimeStamp = doc["lastActivity"] as? Timestamp
                        let channel = Channel(identifier: document.documentID,
                                              name: doc["name"] as? String,
                                              lastMessage: doc["lastMessage"] as? String,
                                              lastActivity: dateTimeStamp?.dateValue())
                        result.append(channel)
                    }
                }
            }
            self?.conversations = result.sort()
            self?.tableView.reloadData()
        }
    }
    
    fileprivate func addChannel(channelName: String) {
        let db = Firestore.firestore()
        let reference = db.collection("channels").document()
        let channel: [String: Any] = [
            "identifier": reference.documentID,
            "name": channelName
        ]
        reference.setData(channel,
                          completion: { error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                          })
    }
}
