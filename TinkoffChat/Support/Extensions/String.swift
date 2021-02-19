//
//  String.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 19.02.2021.
//

import Foundation

extension String {
    
    func getStringFirstChars() -> String {
        var stringFirstChars = ""
        let stringArray = self.components(separatedBy: " ")
        for string in stringArray {
            if let firstChar = string.first {
                stringFirstChars.append(firstChar)
            }
        }
        return stringFirstChars
    }
}
