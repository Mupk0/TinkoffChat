//
//  Log.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 13.02.2021.
//

import Foundation

class Log {

    static func show(message: String, function: String = #function) {
        if Constants.IS_LOG_DISPLAYED {
            #if DEBUG
            print("\(message): \(function)")
            #endif
        }
    }
}
