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
    
    private let messageView = MessageView()
    private let messageTextView = UITextView()
    private let placeholderLabel = UILabel()
    private let sendIconImageView = UIImageView()
    
    private let textViewFont: UIFont = .systemFont(ofSize: 16, weight: .regular)
    
    private var messages: [Message] = []
    
    private let channelId: String
    
    init(userName: String, channelId: String) {
        self.channelId = channelId
        
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
        getData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    private func configureViews() {
        
        view.addSubview(tableView)
        view.addSubview(messageView)
        messageView.addSubview(messageTextView)
        messageView.addSubview(sendIconImageView)
        messageTextView.addSubview(placeholderLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        sendIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            messageView.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.height * 0.35),
            messageView.topAnchor.constraint(equalTo: messageTextView.topAnchor, constant: -17),
            messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            messageTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 32),
            messageTextView.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -30),
            messageTextView.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -19),
            messageTextView.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 50),
            
            sendIconImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 19),
            sendIconImageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 19),
            sendIconImageView.trailingAnchor.constraint(equalTo: messageTextView.trailingAnchor, constant: -10),
            sendIconImageView.centerYAnchor.constraint(equalTo: messageTextView.centerYAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(OutgoingMessageTableViewCell.self,
                           forCellReuseIdentifier: OutgoingMessageTableViewCell.reuseIdentifier)
        tableView.register(IncomingMessageTableViewCell.self,
                           forCellReuseIdentifier: IncomingMessageTableViewCell.reuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none

        messageTextView.delegate = self
        
        messageTextView.isScrollEnabled = false
        messageTextView.sizeToFit()
        messageTextView.layer.cornerRadius = 16
        messageTextView.textContainerInset = UIEdgeInsets(top: 5, left: 17, bottom: 5, right: 30)
        messageTextView.font = textViewFont

        placeholderLabel.text = "Your message here..."
        placeholderLabel.font = textViewFont
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 22, y: (textViewFont.pointSize) / 2)
        placeholderLabel.textColor = .lightGray
        
        sendIconImageView.isHidden = true
        sendIconImageView.image = #imageLiteral(resourceName: "icon_send")
        sendIconImageView.contentMode = .scaleAspectFit
        sendIconImageView.isUserInteractionEnabled = true
        sendIconImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                    action: #selector(didTapAddMessageButton)))
        
        hideKeyboardWhenTappedAround()
    }
    
    @objc private func didTapAddMessageButton() {
        if let message = messageTextView.text {
            self.addMessage(messageText: message,
                            complition: { status in
                                if status {
                                    self.messageTextView.text = ""
                                }
                            })
        }
    }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let identifier = message.senderId == Settings.shared.deviceId
            ? OutgoingMessageTableViewCell.reuseIdentifier
            : IncomingMessageTableViewCell.reuseIdentifier
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                       for: indexPath) as? MessageCellProtocol & UITableViewCell
        else { fatalError("Wrong Cell Type") }
        cell.setMessageModel(message)
        
        return cell
    }
}

extension ConversationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        sendIconImageView.isHidden = textView.text.isEmpty
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        if newSize.height < view.frame.height * 0.3 {
            var newFrame = textView.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            textView.frame = newFrame
        }
        textView.isScrollEnabled = newSize.height > view.frame.height * 0.3
    }
}

extension ConversationViewController {
    fileprivate func getData() {
        var result: [Message] = []
        
        let db = Firestore.firestore()
        let reference = db.collection("channels").document(channelId).collection("messages")
        
        reference.addSnapshotListener { [weak self] snapshot, _ in
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
            self?.messages = result.sort()
            self?.tableView.reloadData()
        }
    }
    
    fileprivate func addMessage(messageText: String,
                                complition: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let reference = db.collection("channels").document(channelId).collection("messages")

        if let deviceId = Settings.shared.deviceId {
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
