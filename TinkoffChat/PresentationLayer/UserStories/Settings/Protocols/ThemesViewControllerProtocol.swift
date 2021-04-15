//
//  ThemesViewControllerProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.04.2021.
//

import Foundation

protocol ThemesViewControllerProtocol {
    var delegate: ThemesViewControllerDelegate? { get set }
    var didSelectThemeType: ((ThemeType) -> Void)? { get set }
}
