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
            "Over fact all son tell this any his. No insisted confined of weddings to returned to debating rendered. Keeps order fully so do party means young. Table nay him jokes quick. In felicity up to graceful mistaken horrible consider. Abode never think to at. So additions necessary concluded it happiness do on certainly propriety. On in green taken do offer witty of.",
            "Kept in sent gave feel will oh it we. Has pleasure procured men laughing shutters nay. Old insipidity motionless continuing law shy partiality. Depending acuteness dependent eat use dejection. Unpleasing astonished discovered not nor shy. Morning hearted now met yet beloved evening. Has and upon his last here must.",
            "He difficult contented we determine ourselves me am earnestly. Hour no find it park. Eat welcomed any husbands moderate. Led was misery played waited almost cousin living. Of intention contained is by middleton am. Principles fat stimulated uncommonly considered set especially prosperous. Sons at park mr meet as fact like.",
            "At as in understood an remarkably solicitude. Mean them very seen she she. Use totally written the observe pressed justice. Instantly cordially far intention recommend estimable yet her his. Ladies stairs enough esteem add fat all enable. Needed its design number winter see. Oh be me sure wise sons no. Piqued ye of am spirit regret. Stimulated discretion impossible admiration in particular conviction up.",
            "Ladies others the six desire age. Bred am soon park past read by lain. As excuse eldest no moment. An delight beloved up garrets am cottage private. The far attachment discovered celebrated decisively surrounded for and. Sir new the particular frequently indulgence excellence how. Wishing an if he sixteen visited tedious subject it. Mind mrs yet did quit high even you went. Sex against the two however not nothing prudent colonel greater. Up husband removed parties staying he subject mr.",
            "For norland produce age wishing. To figure on it spring season up. Her provision acuteness had excellent two why intention. As called mr needed praise at. Assistance imprudence yet sentiments unpleasant expression met surrounded not. Be at talked ye though secure nearer.",
            "Extremity sweetness difficult behaviour he of. On disposal of as landlord horrible. Afraid at highly months do things on at. Situation recommend objection do intention so questions. As greatly removed calling pleased improve an. Last ask him cold feel met spot shy want. Children me laughing we prospect answered followed. At it went is song that held help face.",
            "Unwilling sportsmen he in questions september therefore described so. Attacks may set few believe moments was. Reasonably how possession shy way introduced age inquietude. Missed he engage no exeter of. Still tried means we aware order among on. Eldest father can design tastes did joy settle. Roused future he ye an marked. Arose mr rapid in so vexed words. Gay welcome led add lasting chiefly say looking.",
            "May indulgence difficulty ham can put especially. Bringing remember for supplied her why was confined. Middleton principle did she procuring extensive believing add. Weather adapted prepare oh is calling. These wrong of he which there smile to my front. He fruit oh enjoy it of whose table. Cultivated occasional old her unpleasing unpleasant. At as do be against pasture covered viewing started. Enjoyed me settled mr respect no spirits civilly.",
            "Boy desirous families prepared gay reserved add ecstatic say. Replied joy age visitor nothing cottage. Mrs door paid led loud sure easy read. Hastily at perhaps as neither or ye fertile tedious visitor. Use fine bed none call busy dull when. Quiet ought match my right by table means. Principles up do in me favourable affronting. Twenty mother denied effect we to do on.",
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
