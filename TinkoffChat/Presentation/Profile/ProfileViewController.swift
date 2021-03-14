//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 19.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let backView = MainBackgroundView()
    
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
    
    private let userNameLabel: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.sizeToFit()
        return textField
    }()
    
    private let userDescriptionLabel: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .light)
        textView.isScrollEnabled = false
        textView.sizeToFit()
        return textView
    }()
    
    private let editButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Edit", for: .normal)
        return button
    }()
    
    private let cancelButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Cancel", for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let editProfileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 13
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.isHidden = true
        return stackView
    }()
    
    private let gcdButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Save GCD", for: .normal)
        return button
    }()
    
    private let operationButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Save Operations", for: .normal)
        return button
    }()
    
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
        hideKeyboardWhenTappedAround()
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
        backView.addSubview(cancelButton)
        backView.addSubview(editButton)
        backView.addSubview(editProfileStackView)
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        userAvatarView.translatesAutoresizingMaskIntoConstraints = false
        userAvatarLabel.translatesAutoresizingMaskIntoConstraints = false
        userAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
            userDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: cancelButton.topAnchor, constant: -50),
            
            cancelButton.bottomAnchor.constraint(equalTo: editButton.topAnchor, constant: -10),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -31),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            editButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 62),
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -62),
            editButton.heightAnchor.constraint(equalToConstant: 40),
            
            editProfileStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            editProfileStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 31),
            editProfileStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -31),
            editProfileStackView.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        userAvatarView.layoutIfNeeded()
        
        userAvatarView.layer.cornerRadius = userAvatarView.frame.height / 2
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.height / 2
        userAvatarImageView.addGestureRecognizer(UITapGestureRecognizer(target:self,
                                                                        action: #selector(showImagePickerAlert)))
        
        userAvatarLabel.text = userName.getStringFirstChars()
        userNameLabel.text = userName
        userDescriptionLabel.text = userDescription
        
        editProfileStackView.addArrangedSubview(gcdButton)
        editProfileStackView.addArrangedSubview(operationButton)
        
        editButton.addGestureRecognizer(UITapGestureRecognizer(target:self,
                                                               action: #selector(didTapEditButton)))
        cancelButton.addGestureRecognizer(UITapGestureRecognizer(target:self,
                                                                 action: #selector(didTapCancelButton)))
    }
    
    @objc private func showImagePickerAlert() {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        imagePicker?.present()
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapEditButton() {
        editButton.isHidden = true
        cancelButton.isHidden = false
        editProfileStackView.isHidden = false
        userNameLabel.becomeFirstResponder()
    }
    
    @objc private func didTapCancelButton() {
        editButton.isHidden = false
        cancelButton.isHidden = true
        editProfileStackView.isHidden = true
    }
}

extension ProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        userAvatarImageView.image = image
        imagePicker = nil
    }
}
