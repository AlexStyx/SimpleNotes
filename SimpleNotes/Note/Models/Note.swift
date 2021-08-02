//
//  Note.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/2/21.
//

import Foundation
import Firebase

struct Note {
    let id: String
    let title: String
    let text: String
    let date: Date
    let reference: DatabaseReference?
    var dateString: String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        return "\(day).\(month).\(year)"
    }
    
    var dataDict: [String: Any] {
        [JSONKeys.id: id, JSONKeys.title: title, JSONKeys.text: text, JSONKeys.date: dateString]
    }
    
    init(id: String, title: String, text: String, date: Date) {
        self.id = id
        self.title = title
        self.text = text
        self.date = date
        self.reference = nil
    }
    
    init?(snaphsot: DataSnapshot) {
        guard let value = snaphsot.value as? [String: Any] else { return nil }
        guard let id = value[JSONKeys.id] as? String else { return nil }
        guard let title = value[JSONKeys.title] as? String else { return nil }
        guard let text = value[JSONKeys.text] as? String else { return nil }
        guard let dateString = value[JSONKeys.date] as? String else { return nil }
        
        self.id = id
        self.title = title
        self.text = text
        self.date = Date.fromString(dateString: dateString) ?? Date()
        self.reference = snaphsot.ref
    }
    
    struct JSONKeys {
        static let id = "id"
        static let title = "title"
        static let text = "text"
        static let date = "date"
    }
}


extension Date {
    static func fromString(dateString: String) -> Date? {
        let components = dateString.split(separator: ".").compactMap { Int($0) }
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 10800), era: nil, year: components[2], month: components[1], day: components[0], hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        let date = calendar.date(from: dateComponents)
        return date
    }
}
