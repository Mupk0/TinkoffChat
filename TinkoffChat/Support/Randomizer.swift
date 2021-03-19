//
//  Randomizer.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 01.03.2021.
//

import Foundation

class Randomizer {
    
    static let shared = Randomizer()
    
    func getDate() -> Date? {
        let date = Date()
        let calendar = Calendar.current
        guard let randomDayBefore = calendar.date(byAdding: .day,
                                                  value: Int.random(in: -5...0),
                                                  to: date) else { return nil }
        
        let maxHourInRandomDay = Calendar.current.component(.hour, from: randomDayBefore)
        let randomHour = (0...maxHourInRandomDay).randomElement()
        
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: randomDayBefore)

        dateComponents.setValue(randomHour, for: .hour)
        return calendar.date(from: dateComponents)
    }
    
    func getText() -> String? {
        let strings: [String?] = [
            "Hello",
            """
            Over fact all son tell this any his.
            No insisted confined of weddings to returned to debating rendered.
            Keeps order fully so do party means young. Table nay him jokes quick.
            In felicity up to graceful mistaken horrible consider.
            Abode never think to at.
            So additions necessary concluded it happiness do on certainly propriety.
            On in green taken do offer witty of.
            """,
            """
            Kept in sent gave feel will oh it we.
            Has pleasure procured men laughing shutters nay.
            Old insipidity motionless continuing law shy partiality.
            Depending acuteness dependent eat use dejection.
            Unpleasing astonished discovered not nor shy.
            Morning hearted now met yet beloved evening.
            Has and upon his last here must.
            """,
            """
            He difficult contented we determine ourselves me am earnestly.
            Hour no find it park. Eat welcomed any husbands moderate.
            Led was misery played waited almost cousin living.
            Of intention contained is by middleton am.
            Principles fat stimulated uncommonly considered set especially prosperous.
            Sons at park mr meet as fact like.
            """,
            """
            At as in understood an remarkably solicitude.
            Mean them very seen she she.
            Use totally written the observe pressed justice.
            Instantly cordially far intention recommend estimable yet her his.
            Ladies stairs enough esteem add fat all enable.
            Needed its design number winter see.
            Oh be me sure wise sons no.
            Piqued ye of am spirit regret.
            Stimulated discretion impossible admiration in particular conviction up.
            """,
            nil]
        
        return strings.randomElement() ?? nil
    }
    
    func getName() -> String? {
        let names: [String?] = [
            "Alexia Beasley",
            "Lauren Beard",
            "Esme Sanford",
            "Leyla Smith",
            "Shane Fisher",
            "Rosie O'Neill",
            "Daisy Bright",
            "Talia Hodge",
            "Carla Hart",
            "Angela Cardenas",
            nil]
        
        return names.randomElement() ?? nil
    }
    
}
