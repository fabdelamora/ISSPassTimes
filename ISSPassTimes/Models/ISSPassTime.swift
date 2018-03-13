//
//  ISSPassTime.swift
//  ISSPassTimes
//
//  Created by Fabriccio De la Mora on 3/13/18.
//  Copyright © 2018 Fabriccio De la Mora. All rights reserved.
//

import ObjectMapper

class ISSPassTime: Mappable{
    var duration: Int = 0
    var riseTime: Int = 0
    
    var durationMinutes: Int = 0
    var timeZonedRiseTime: String = ""
    
    
    required public convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        duration          <- map["duration"]
        riseTime          <- map["risetime"]
        durationMinutes = Int(duration/60)
        timeZonedRiseTime = Date(timeIntervalSince1970: Double(riseTime)).timezonedString()
    }
}


