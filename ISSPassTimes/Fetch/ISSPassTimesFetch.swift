//
//  ISSPassTimesFetch.swift
//  ISSPassTimes
//
//  Created by Fabriccio De la Mora on 3/13/18.
//  Copyright © 2018 Fabriccio De la Mora. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import CoreLocation

class ISSPassTimesFetch: NSObject {
    private let passTimesString = "http://api.open-notify.org/iss-pass.json"
    private let numberOfResults = 5
    
    func fetchPassTimes(forLocation location:CLLocation, success:@escaping ([ISSPassTime], String)-> Void){
        let parameters: Parameters = [
            "lat": location.coordinate.latitude,
            "lon": location.coordinate.longitude,
            "passes": numberOfResults,
            "altitude": location.altitude
        ]
        
        Alamofire.request(passTimesString,
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding(destination: .queryString),
                          headers: nil).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                let results = ((value as! [String : Any])["response"] as! [[String : Any]])
                                self.mapItems(results, success: { (passTimes) -> (Void) in
                                    success(passTimes, "")
                                })
                            case .failure(let error):
                                print(error)
                                success([ISSPassTime](),error.localizedDescription)
                            }
        }
    }
    
    func mapItems(_ items: [[String: Any]], success:(([ISSPassTime])->(Void))?){
        var passTimes: [ISSPassTime] = []
        
        for passTime : [String:Any] in items {
            let entry: ISSPassTime = Mapper<ISSPassTime>().map(JSONObject: passTime)!
            passTimes.append(entry)
        }
        
        success?(passTimes)
    }
}
