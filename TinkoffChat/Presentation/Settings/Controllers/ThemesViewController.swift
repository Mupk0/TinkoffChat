//
//  ThemesViewController.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 07.03.2021.
//

import UIKit

protocol ThemesViewControllerProtocol {
    var delegate: ThemesViewControllerDelegate? { get set }
    var didSelectThemeType: ((ThemeType) -> ())? { get set }
}

protocol ThemesViewControllerDelegate: class {
    func didSelectTheme(_ themeType: ThemeType)
}

class ThemesViewController: UIViewController, ThemesViewControllerProtocol {
    
    private let classicThemeView = ThemeTypeView(.Classic)
    private let dayThemeView = ThemeTypeView(.Day)
    private let nightThemeView = ThemeTypeView(.Night)
    
    weak var delegate: ThemesViewControllerDelegate?
    var didSelectThemeType: ((ThemeType) -> ())?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        updateCurrentTheme()
        setupClosures()
    }
    
    private func configureViews() {
        view.addSubview(classicThemeView)
        view.addSubview(dayThemeView)
        view.addSubview(nightThemeView)
        
        classicThemeView.translatesAutoresizingMaskIntoConstraints = false
        dayThemeView.translatesAutoresizingMaskIntoConstraints = false
        nightThemeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            classicThemeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 162),
            classicThemeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            classicThemeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            classicThemeView.heightAnchor.constraint(equalToConstant: 57),
            
            dayThemeView.topAnchor.constraint(equalTo: classicThemeView.bottomAnchor, constant: 80),
            dayThemeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            dayThemeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            dayThemeView.heightAnchor.constraint(equalToConstant: 57),
            
            nightThemeView.topAnchor.constraint(equalTo: dayThemeView.bottomAnchor, constant: 80),
            nightThemeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            nightThemeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            nightThemeView.heightAnchor.constraint(equalToConstant: 57),
        ])
        
        view.backgroundColor = UIColor(red: 0.098, green: 0.21, blue: 0.379, alpha: 1)
    }
    
    private func setupClosures() {
        classicThemeView.didTapTheme = { [weak self] in
            self?.didSelectTheme(.Classic)
        }
        dayThemeView.didTapTheme = { [weak self] in
            self?.didSelectTheme(.Day)
        }
        nightThemeView.didTapTheme = { [weak self] in
            self?.didSelectTheme(.Night)
        }
    }
    
    private func updateCurrentTheme() {
        let themeType = ThemeType.init(Settings.shared.themeType)
        didSelectTheme(themeType)
    }
    
    private func didSelectTheme(_ themeType: ThemeType) {
        classicThemeView.isSelected = themeType == .Classic
        dayThemeView.isSelected = themeType == .Day
        nightThemeView.isSelected = themeType == .Night
        
        delegate?.didSelectTheme(themeType)
        didSelectThemeType?(themeType)
        
        ThemeSwitcher.shared.setTheme(themeType)
    }
}
