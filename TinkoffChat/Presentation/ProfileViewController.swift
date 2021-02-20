//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 19.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let userAvatarView = UIView()
    private let userAvatarLabel = UILabel()
    private let userAvatarImageView = UIImageView()
    
    private let userNameLabel = UILabel()
    private let userInfoLabel = UILabel()
    
    private let editButton = UIButton(type: .system)
    
    private var imagePicker: ImagePicker?
    
    private let userName = "Marina Dudarenko"
    private let userInfo = "UX/UI designer, web-designer Moscow, Russia"
    
    init() {
        super.init(nibName: nil, bundle: nil)

        print("frame for edit button in init(): \(editButton.frame)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        print("frame for edit button in viewDidLoad(): \(editButton.frame)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("frame for edit button in viewWillAppear(): \(editButton.frame)")
    }
    
    private func setupViews() {
        
        view.addSubview(userAvatarView)
        userAvatarView.addSubview(userAvatarLabel)
        userAvatarView.addSubview(userAvatarImageView)
        view.addSubview(userNameLabel)
        view.addSubview(userInfoLabel)
        view.addSubview(editButton)
        
        userAvatarView.translatesAutoresizingMaskIntoConstraints = false
        userAvatarLabel.translatesAutoresizingMaskIntoConstraints = false
        userAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userAvatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            userAvatarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 68),
            userAvatarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -68),
            userAvatarView.heightAnchor.constraint(equalTo: userAvatarView.widthAnchor, multiplier: 1),
            
            userAvatarLabel.bottomAnchor.constraint(equalTo: userAvatarView.bottomAnchor, constant: -20),
            userAvatarLabel.topAnchor.constraint(equalTo: userAvatarView.topAnchor, constant: 20),
            userAvatarLabel.leadingAnchor.constraint(equalTo: userAvatarView.leadingAnchor, constant: 20),
            userAvatarLabel.trailingAnchor.constraint(equalTo: userAvatarView.trailingAnchor, constant: -20),
            
            userAvatarImageView.bottomAnchor.constraint(equalTo: userAvatarView.bottomAnchor),
            userAvatarImageView.topAnchor.constraint(equalTo: userAvatarView.topAnchor),
            userAvatarImageView.leadingAnchor.constraint(equalTo: userAvatarView.leadingAnchor),
            userAvatarImageView.trailingAnchor.constraint(equalTo: userAvatarView.trailingAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: userAvatarView.bottomAnchor, constant: 32),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameLabel.leadingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            userInfoLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 32),
            userInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userInfoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 78),
            userInfoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -78),
            
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            editButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 62),
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -62),
            editButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        userAvatarView.layoutIfNeeded()
        
        view.backgroundColor = .white
        
        userAvatarView.layer.cornerRadius = userAvatarView.frame.height / 2
        userAvatarView.backgroundColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1)
        
        userAvatarLabel.text = userName.getStringFirstChars()
        userAvatarLabel.textAlignment = .center
        userAvatarLabel.textColor = .black
        userAvatarLabel.font = UIFont.boldSystemFont(ofSize: 120)
        userAvatarLabel.adjustsFontSizeToFitWidth = true
        userAvatarLabel.sizeToFit()
        userAvatarLabel.baselineAdjustment = .alignCenters
        userAvatarLabel.clipsToBounds = true
        
        userAvatarImageView.contentMode = .scaleAspectFill
        userAvatarImageView.isUserInteractionEnabled = true
        userAvatarImageView.addGestureRecognizer(UITapGestureRecognizer(target:self,
                                                                         action: #selector(showImagePickerAlert)))
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.height / 2
        userAvatarImageView.clipsToBounds = true
        
        userNameLabel.textColor = .black
        userNameLabel.textAlignment = .center
        userNameLabel.lineBreakMode = .byWordWrapping
        userNameLabel.numberOfLines = 0
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        userNameLabel.text = userName
        userNameLabel.sizeToFit()
        
        userInfoLabel.textColor = .black
        userInfoLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        userInfoLabel.lineBreakMode = .byWordWrapping
        userInfoLabel.numberOfLines = 0
        userInfoLabel.text = userInfo
        
        editButton.setTitle("Edit", for: .normal)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        editButton.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        editButton.layer.cornerRadius = 14
    }
    
    @objc private func showImagePickerAlert() {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        imagePicker?.present()
    }
}

extension ProfileViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        userAvatarImageView.image = image
        imagePicker = nil
    }
}
