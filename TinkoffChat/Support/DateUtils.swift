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
            let startOfCurrentDay = calendar.startOfDay(for: Date())
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = date > startOfCurrentDay ? "HH:mm" : "dd MMM"
            
            return dateFormatter.string(from: date)
        }
        return "Unknown Date"
    }
}
