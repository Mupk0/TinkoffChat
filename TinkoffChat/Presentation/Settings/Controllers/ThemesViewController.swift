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
    
    private let backView = ThemeControllerBackgroundView()
    
    private let classicThemeView = ThemeTypeView(.Classic)
    private let dayThemeView = ThemeTypeView(.Day)
    private let nightThemeView = ThemeTypeView(.Night)
    
    weak var delegate: ThemesViewControllerDelegate?
    /*
     retain cycle при использовании данного делегата может возникнуть в том случае,
     когда он указан сильной ссылкой (без weak)
     */
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
        view.addSubview(backView)
        view.addSubview(classicThemeView)
        view.addSubview(dayThemeView)
        view.addSubview(nightThemeView)
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        classicThemeView.translatesAutoresizingMaskIntoConstraints = false
        dayThemeView.translatesAutoresizingMaskIntoConstraints = false
        nightThemeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            classicThemeView.bottomAnchor.constraint(equalTo: dayThemeView.topAnchor, constant: -80),
            classicThemeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            classicThemeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            classicThemeView.heightAnchor.constraint(equalToConstant: 57),
            
            dayThemeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dayThemeView.topAnchor.constraint(equalTo: classicThemeView.bottomAnchor, constant: 80),
            dayThemeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            dayThemeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            dayThemeView.heightAnchor.constraint(equalToConstant: 57),
            
            nightThemeView.topAnchor.constraint(equalTo: dayThemeView.bottomAnchor, constant: 80),
            nightThemeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            nightThemeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            nightThemeView.heightAnchor.constraint(equalToConstant: 57),
        ])
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
        
        ThemeSwitcher.shared.setTheme(themeType)
        
        delegate?.didSelectTheme(themeType)
        didSelectThemeType?(themeType)
        /*
         retain cycle возникнет при использовании данного замыкания,
         если в контроллере есть ссылка на замыкание, в котором мы используем self сильной ссылкой
         */

    }
}