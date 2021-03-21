//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 28.02.2021.
//

import UIKit
import FirebaseFirestore

class ConversationViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private var messages: [Message] = []
    
    private let channelId: String
    
    init(userName: String, channelId: String) {
        self.channelId = channelId
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = userName
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        let addMessageButton = UIBarButtonItem(title: "+",
                                               style: .plain,
                                               target: self,
                                               action: #selector(didTapAddChannelButton))
        navigationItem.rightBarButtonItem = addMessageButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        loadMessages()
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(OutgoingMessageTableViewCell.self,
                           forCellReuseIdentifier: OutgoingMessageTableViewCell.reuseIdentifier)
        tableView.register(IncomingMessageTableViewCell.self,
                           forCellReuseIdentifier: IncomingMessageTableViewCell.reuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    @objc private func didTapAddChannelButton() {
        print("didTapAddChannelButton")
        let alertController = UIAlertController(title: "Enter Message",
                                   message: nil,
                                   preferredStyle: .alert)
        alertController.addTextField()

        let submitAction = UIAlertAction(title: "Add", style: .default) { [unowned alertController] _ in
            if let textField = alertController.textFields?[0], let message = textField.text {
                self.addMessage(messageText: message,
                                complition: { status in
                                    if status {
                                        self.loadMessages()
                                    }
                                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: { _ in })

        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    private func loadMessages() {
        getData(complition: { [weak self] messages in
            self?.messages = messages
            self?.tableView.reloadData()
        })
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let identifier = message.senderId == Constants.deviceId
            ? OutgoingMessageTableViewCell.reuseIdentifier
            : IncomingMessageTableViewCell.reuseIdentifier
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                       for: indexPath) as? MessageCellProtocol & UITableViewCell
        else { fatalError("Wrong Cell Type") }
        cell.setMessageModel(message)
        
        return cell
    }
}

extension ConversationViewController {
    fileprivate func getData(complition: @escaping ([Message]) -> Void) {
        var result: [Message] = []

        let db = Firestore.firestore()
        let reference = db.collection("channels").document(channelId).collection("messages")
        reference.addSnapshotListener { snapshot, _ in // some code
            if let documents = snapshot?.documents {
                for document in documents {
                    let doc = document.data()
                    print(doc)
                    let messageDate = doc["created"] as? Timestamp
                    let message = Message(content: doc["content"] as? String,
                                          created: messageDate?.dateValue(),
                                          senderId: doc["senderId"] as? String,
                                          senderName: doc["senderName"] as? String)
                    result.append(message)
                }
            }
            complition(result.sort())
        }
    }
    
    fileprivate func addMessage(messageText: String,
                                complition: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let reference = db.collection("channels").document(channelId).collection("messages")

        if let deviceId = Constants.deviceId {
            let message: [String: Any] = [
                "content": messageText,
                "created": Date(),
                "senderId": deviceId,
                "senderName": "Кулагин Дмитрий"
            ]
            
            reference.addDocument(data: message,
                              completion: { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    complition(false)
                                } else {
                                    complition(true)
                                }
                              })
        }
    }
}
