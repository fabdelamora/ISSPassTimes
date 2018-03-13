//
//  ISSPassTimesTests.swift
//  ISSPassTimesTests
//
//  Created by Fabriccio De la Mora on 3/13/18.
//  Copyright © 2018 Fabriccio De la Mora. All rights reserved.
//

import XCTest
@testable import ISSPassTimes

class ISSPassTimesTests: XCTestCase {
    
    func testParseDataCorrectly() {
        let passTimesDictionary = [["risetime":3000,
                                    "duration":300
            ],
                                   ["risetime":3000,
                                    "duration":300
            ],
                                   ["risetime":3000,
                                    "duration":300
            ]]
        
        let timesFetch = ISSPassTimesFetch()
        var passTimes = [ISSPassTime]()
        
        timesFetch.mapItems(passTimesDictionary) { (times) -> (Void) in
            passTimes = times
        }

        XCTAssertNotEqual(passTimes.count, 2)
        XCTAssertEqual(passTimes.count, 3)
        XCTAssertNotEqual(passTimes.count, 4)
    }
    
    func testParseFailsGracefully() {
        let passTimesDictionary = [["riseime":3000,
                                    "duration":300
            ],
                                   ["risetime":3000,
                                    "duraion":300
            ],
                                   ["risetime":3000,
                                    "dur":300
            ]]
        
        let timesFetch = ISSPassTimesFetch()
        var passTimes = [ISSPassTime]()
        
        timesFetch.mapItems(passTimesDictionary) { (times) -> (Void) in
            passTimes = times
        }

        XCTAssertEqual(passTimes.count, 3)
        XCTAssertEqual(passTimes[0].riseTime, 0)
        XCTAssertEqual(passTimes[1].duration, 0)
        XCTAssertEqual(passTimes[2].duration, 0)
    }
}
