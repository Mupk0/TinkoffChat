//
//  DateUtils.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 01.03.2021.
//

import Foundation

class DateUtils {
    
    static let shared = DateUtils()
    
    func getStringFromDate(_ date: Date?) -> String {
        if let date = date {
            let calendar = Calendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = calendar.isDateInToday(date) ? "HH:mm" : "dd MMM"
            
            return dateFormatter.string(from: date)
        }
        return "Unknown Date"
    }
}
