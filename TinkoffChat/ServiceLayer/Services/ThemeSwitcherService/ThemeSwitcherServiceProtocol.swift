//
//  ThemeSwitcherServiceProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

protocol ThemeSwitcherServiceProtocol {
    func save(theme: ThemeType)
    func load(completionHandler: @escaping (ThemeType?) -> Void)
}
