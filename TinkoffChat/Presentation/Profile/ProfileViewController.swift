//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 19.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let backView = ThemeBackgroundView()
    
    private let userAvatarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1)
        return view
    }()
    
    private let userAvatarLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 120)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.baselineAdjustment = .alignCenters
        label.clipsToBounds = true
        return label
    }()
    
    private let userAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let userNameLabel: MainTitleLabel = {
        let label = MainTitleLabel()
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.sizeToFit()
        return label
    }()
    
    private let userDescriptionLabel: MainTitleLabel = {
        let label = MainTitleLabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let editButton = ProfileEditButton()
    
    private var imagePicker: ImagePicker?
    
    private let userName = "Marina Dudarenko"
    private let userDescription = "UX/UI designer, web-designer Moscow, Russia"
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title =  "Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapCloseButton))
        //print("frame for edit button in init(): \(editButton.frame)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        //print("frame for edit button in viewDidLoad(): \(editButton.frame)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //print("frame for edit button in viewWillAppear(): \(editButton.frame)")
    }
    
    private func setupViews() {
        view.addSubview(backView)
        backView.addSubview(userAvatarView)
        userAvatarView.addSubview(userAvatarLabel)
        userAvatarView.addSubview(userAvatarImageView)
        backView.addSubview(userNameLabel)
        backView.addSubview(userDescriptionLabel)
        backView.addSubview(editButton)
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        userAvatarView.translatesAutoresizingMaskIntoConstraints = false
        userAvatarLabel.translatesAutoresizingMaskIntoConstraints = false
        userAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
            
            userDescriptionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 32),
            userDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userDescriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 78),
            userDescriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -78),
            
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            editButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 62),
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -62),
            editButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        userAvatarView.layoutIfNeeded()
        
        userAvatarView.layer.cornerRadius = userAvatarView.frame.height / 2
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.height / 2
        userAvatarImageView.addGestureRecognizer(UITapGestureRecognizer(target:self,
                                                                        action: #selector(showImagePickerAlert)))
        
        userAvatarLabel.text = userName.getStringFirstChars()
        userNameLabel.text = userName
        userDescriptionLabel.text = userDescription
    }
    
    @objc private func showImagePickerAlert() {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        imagePicker?.present()
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
}

extension ProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        userAvatarImageView.image = image
        imagePicker = nil
    }
}
