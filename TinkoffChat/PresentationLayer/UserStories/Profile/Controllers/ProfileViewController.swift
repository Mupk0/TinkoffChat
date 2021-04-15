//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 19.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Private Enums
    private enum SaveButtonsState {
        case enabled
        case disabled
    }
    
    private enum ProfileState {
        case show
        case edit
    }
    // MARK: - Private Subviews
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
    
    private let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.isEnabled = false
        textField.sizeToFit()
        return textField
    }()
    
    private let userDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .light)
        textView.isScrollEnabled = false
        textView.isEditable = false
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
    
    private let saveButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicatorView: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            indicatorView = UIActivityIndicatorView(style: .large)
        } else {
            indicatorView = UIActivityIndicatorView(style: .gray)
        }
        return indicatorView
    }()
    
    private var imagePicker: ImagePickerProtocol?
    
    // MARK: - Profile Datas
    private var savedProfile: ProfileProtocol?
    
    private var unsavedProfile: ProfileProtocol? {
        didSet {
            updateViewsByProfile(unsavedProfile)
            hasUnsavedChanges = !(savedProfile?.isEquatable(newValue: unsavedProfile) ?? false)
        }
    }
    // MARK: - Controller states
    private var hasUnsavedChanges: Bool = false {
        didSet {
            setStateOfSaveButtons(to: hasUnsavedChanges ? .enabled : .disabled)
        }
    }
    
    private var profileState: ProfileState = .show {
        didSet {
            editButton.isHidden = profileState != .show
            cancelButton.isHidden = profileState == .show
            editProfileStackView.isHidden = profileState == .show
            
            userNameTextField.isEnabled = profileState != .show
            userDescriptionTextView.isEditable = profileState != .show
            setStateOfSaveButtons(to: profileState == .show ? .enabled : .disabled)
        }
    }
    
    private let presentationAssembly: PresentationAssemblyProtocol
    private let dataModel: ProfileDataModelProtocol
    
    init(presentationAssembly: PresentationAssemblyProtocol,
         dataModel: ProfileDataModelProtocol) {
        
        self.presentationAssembly = presentationAssembly
        self.dataModel = dataModel
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = "Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapCloseButton))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        loadProfile()
        hideKeyboardWhenTappedAround()
        
        userNameTextField.delegate = self
        userDescriptionTextView.delegate = self
    }
    // MARK: - Views configure methods
    private func setupViews() {
        view.addSubview(backView)
        backView.addSubview(userAvatarView)
        userAvatarView.addSubview(userAvatarLabel)
        userAvatarView.addSubview(userAvatarImageView)
        backView.addSubview(userNameTextField)
        backView.addSubview(userDescriptionTextView)
        backView.addSubview(cancelButton)
        backView.addSubview(editButton)
        backView.addSubview(editProfileStackView)
        backView.addSubview(activityIndicator)
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        userAvatarView.translatesAutoresizingMaskIntoConstraints = false
        userAvatarLabel.translatesAutoresizingMaskIntoConstraints = false
        userAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileStackView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            userNameTextField.topAnchor.constraint(equalTo: userAvatarView.bottomAnchor, constant: 32),
            userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameTextField.leadingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            userNameTextField.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            userDescriptionTextView.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 32),
            userDescriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userDescriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 78),
            userDescriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -78),
            userDescriptionTextView.bottomAnchor.constraint(lessThanOrEqualTo: activityIndicator.topAnchor, constant: -10),
            
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
            
            activityIndicator.bottomAnchor.constraint(equalTo: editButton.topAnchor, constant: -45),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 90),
            activityIndicator.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        userAvatarView.layoutIfNeeded()
        
        userAvatarView.layer.cornerRadius = userAvatarView.frame.height / 2
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.height / 2
        userAvatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                        action: #selector(showImagePickerAlert)))
        
        editProfileStackView.addArrangedSubview(saveButton)
        
        editButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(didTapEditButton)))
        cancelButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                 action: #selector(didTapCancelButton)))
        
        saveButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(didTapSaveButton)))
    }
    
    private func updateViewsByProfile(_ profile: ProfileProtocol?) {
        userNameTextField.text = unsavedProfile?.userName ?? "Your Name"
        userDescriptionTextView.text = unsavedProfile?.about ?? "Add Some Information About you"
        userAvatarLabel.text = userNameTextField.text?.getStringFirstChars()
        if let photoData = unsavedProfile?.photo {
            userAvatarImageView.image = UIImage(data: photoData)
        }
    }
    
    private func setStateOfSaveButtons(to state: SaveButtonsState) {
        saveButton.isEnabled = state == .enabled
    }
    // MARK: - Click Action Methods
    @objc private func showImagePickerAlert() {
        profileState = .edit
        userNameTextField.endEditing(true)
        userDescriptionTextView.endEditing(true)
        imagePicker = presentationAssembly.imagePicker()
        imagePicker?.presentationController = self
        imagePicker?.delegate = self
        imagePicker?.present()
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapEditButton() {
        profileState = .edit
        userNameTextField.becomeFirstResponder()
    }
    
    @objc private func didTapCancelButton() {
        profileState = .show
        unsavedProfile = savedProfile
    }
    
    @objc private func didTapSaveButton() {
        
        activityIndicator.startAnimating()
        cancelButton.isEnabled = false
        setStateOfSaveButtons(to: .disabled)
        
        let profile = Profile(about: userDescriptionTextView.text,
                              photo: userAvatarImageView.image?.pngData(),
                              userName: userNameTextField.text)
        
        dataModel.saveUserProfile(profile,
                                  completionHandler: { error in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        self.activityIndicator.stopAnimating()
                                        self.cancelButton.isEnabled = true
                                        self.setStateOfSaveButtons(to: .enabled)
                                        let window = UIApplication.shared.delegate?.window as? UIWindow
                                        let vc = window?.visibleViewController
                                        if error != nil {
                                            vc?.showAlertWithTitle(title: "Ошибка",
                                                                   message: "Не удалось сохранить данные",
                                                                   buttonLeftTitle: "Ок",
                                                                   buttonRightTitle: "Повторить",
                                                                   buttonLeftAction: { _ in
                                                                    self.profileState = .show
                                                                    self.unsavedProfile = self.savedProfile
                                                                   },
                                                                   buttonRightAction: { _ in
                                                                    self.didTapSaveButton()
                                                                   })
                                        } else {
                                            vc?.showAlertWithTitle(title: "Данные сохранены",
                                                                   buttonLeftTitle: "Ок",
                                                                   buttonLeftAction: { _ in },
                                                                   buttonRightAction: { _ in })
                                            self.hasUnsavedChanges = false
                                            self.savedProfile = profile
                                            self.profileState = .show
                                        }
                                    }
                                  })
    }
    
    // MARK: - Storage methods
    private func loadProfile() {
        dataModel.getUserProfile(completionHandler: { [weak self] (profile, _) in
            self?.savedProfile = profile
            self?.unsavedProfile = profile
        })
    }
}
// MARK: - Image Picker Delegate
extension ProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if image != nil {
            userAvatarImageView.image = image
            setStateOfSaveButtons(to: .enabled)
        } else {
            profileState = hasUnsavedChanges ? .edit : .show
            setStateOfSaveButtons(to: hasUnsavedChanges ? .enabled : .disabled)
        }
        imagePicker = nil
    }
}
// MARK: - UITextField Delegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        unsavedProfile = Profile(about: unsavedProfile?.about,
                                 photo: unsavedProfile?.photo,
                                 userName: textField.text)
    }
}
// MARK: - UITextView Delegate
extension ProfileViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        unsavedProfile = Profile(about: textView.text,
                                 photo: unsavedProfile?.photo,
                                 userName: unsavedProfile?.userName)
    }
}
