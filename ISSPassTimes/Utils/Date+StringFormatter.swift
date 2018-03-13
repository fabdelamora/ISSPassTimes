//
//  Date+StringFormatter.swift
//  ISSPassTimes
//
//  Created by Fabriccio De la Mora on 3/13/18.
//  Copyright © 2018 Fabriccio De la Mora. All rights reserved.
//

import Foundation

extension Date {
    func timezonedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMM d, yyyy, HH:MM"
        dateFormatter.timeZone = TimeZone.current
        
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
