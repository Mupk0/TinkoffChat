//
//  ThemeType.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 07.03.2021.
//

import UIKit

enum ThemeType: String, Codable {
    case Classic
    case Day
    case Night
    
    init(_ string: String?) {
        switch string {
        case ThemeType.Day.rawValue:
            self = .Day
        case ThemeType.Night.rawValue:
            self = .Night
        default:
            self = .Classic
        }
    }
}

extension ThemeType {
    var mainBackgroundColor: UIColor {
        switch self {
        case .Classic:
            return .white
        case .Day:
            return .white
        case .Night:
            return .black
        }
    }
    
    var mainTitleLabelColor: UIColor {
        switch self {
        case .Classic:
            return .black
        case .Day:
            return .black
        case .Night:
            return .white
        }
    }
    
    var incomingMessageBackgroundColor: UIColor {
        switch self {
        case .Classic:
            return UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
        case .Day:
            return UIColor(red: 0.918, green: 0.922, blue: 0.929, alpha: 1)
        case .Night:
            return UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        }
    }
    
    var outgoingMessageBackgroundColor: UIColor {
        switch self {
        case .Classic:
            return UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
        case .Day:
            return UIColor(red: 0.263, green: 0.537, blue: 0.976, alpha: 1)
        case .Night:
            return UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .Classic:
            return .default
        case .Day:
            return .default
        case .Night:
            return .blackTranslucent
        }
    }
    
    var navigationSeparatorColor: UIColor {
        switch self {
        case .Classic:
            return UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        case .Day:
            return UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        case .Night:
            return UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        }
    }
    
    var buttonBackgroundColor: UIColor {
        switch self {
        case .Classic:
            return UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        case .Day:
            return UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        case .Night:
            return UIColor(red: 0.106, green: 0.106, blue: 0.106, alpha: 1)
        }
    }
    
    var navigationBackgroundColor: UIColor {
        switch self {
        case .Classic:
            return UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        case .Day:
            return UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        case .Night:
            return UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
        }
    }
    
    var subtitleLabelColor: UIColor {
        switch self {
        case .Classic:
            return UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        case .Day:
            return UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        case .Night:
            return UIColor(red: 0.553, green: 0.553, blue: 0.576, alpha: 1)
        }
    }
    
    var themeControllerBackgroundColor: UIColor {
        switch self {
        case .Classic:
            return UIColor(red: 0.38, green: 0.49, blue: 0.60, alpha: 1.00)
        case .Day:
            return UIColor(red: 0.38, green: 0.49, blue: 0.60, alpha: 1.00)
        case .Night:
            return UIColor(red: 0.098, green: 0.21, blue: 0.379, alpha: 1)
        }
    }
}
