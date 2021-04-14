//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 28.02.2021.
//

import UIKit
import FirebaseFirestore
import CoreData

class ConversationViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let messageView = MessageView()
    
    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.sizeToFit()
        textView.layer.cornerRadius = 16
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 17, bottom: 5, right: 30)
        textView.font = Constants.TEXT_VIEW_FONT
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Your message here..."
        label.font = Constants.TEXT_VIEW_FONT
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 22, y: (Constants.TEXT_VIEW_FONT.pointSize) / 2)
        label.textColor = .lightGray
        return label
    }()
    
    private let sendIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = #imageLiteral(resourceName: "icon_send")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let channelId: String
    
    private let dataModel: ConversationDataModel
    
    private lazy var fetchRequestController: NSFetchedResultsControllerDelegate = {
        return FetchedResultsControllerDelegate(tableView: tableView)
    }()
    
    private lazy var tableViewDataSource: ConversationTableManagerProtocol = {
        let fetchedResultsController = dataModel.getFetchedRequestController(id: channelId)
        fetchedResultsController.delegate = fetchRequestController
        
        return ConversationTableManager(fetchedResultsController: fetchedResultsController)
    }()
    
    init(channel: SelectedChannelProtocol, dataModel: ConversationDataModel) {
        self.channelId = channel.id
        self.dataModel = dataModel
        
        super.init(nibName: nil, bundle: nil)
        
        dataModel.delegate = self
        
        navigationItem.title = channel.name
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        loadData()
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        
        tableView.dataSource = tableViewDataSource
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        tableView.register(OutgoingMessageTableViewCell.self,
                           forCellReuseIdentifier: OutgoingMessageTableViewCell.reuseIdentifier)
        tableView.register(IncomingMessageTableViewCell.self,
                           forCellReuseIdentifier: IncomingMessageTableViewCell.reuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        sendIconImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                      action: #selector(didTapAddMessageButton)))
        
        messageTextView.delegate = self
        
        hideKeyboardWhenTappedAround()
    }
    
    private func loadData() {
        dataModel.fetchMessages(id: channelId)
    }
    
    @objc private func didTapAddMessageButton() {
        if let message = messageTextView.text, !message.isBlank {
            dataModel.sendMessage(id: channelId, text: message)
        }
    }
}

extension ConversationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        sendIconImageView.isHidden = textView.text.isBlank
        
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

extension ConversationViewController: ConversationDataModelDelegate {
    func messageSenden() {
        messageTextView.text = ""
    }
}
