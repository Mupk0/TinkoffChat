//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 28.02.2021.
//

import UIKit

class ConversationViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private var messages: [ConversationModel] = []
    
    init(userName: String) {
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = userName
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        messages = getData()
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
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let identifier = message.messageType == .incoming
            ? IncomingMessageTableViewCell.reuseIdentifier
            : OutgoingMessageTableViewCell.reuseIdentifier
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                       for: indexPath) as? MessageCellProtocol & UITableViewCell
        else { fatalError("Wrong Cell Type") }
        cell.setMessageModel(message)
        
        return cell
    }
}

extension ConversationViewController {
    fileprivate func getData() -> [ConversationModel] {
        var result: [ConversationModel] = []
        for _ in 0...Int.random(in: 5...15) {
            result.append(ConversationModel(text: Randomizer.shared.getText(),
                                            messageType: MessageType.allCases.randomElement() ?? .outgoing))
        }
        return result
    }
}
