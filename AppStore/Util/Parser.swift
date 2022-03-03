//
//  Parser.swift
//  AppStore
//
//  Created by Yunju Yang on 2022/02/28.
//

import UIKit

class Parser: NSObject {
    
    static let `default` = Parser.init()
    
    private override init() {
        super.init()
    }
    
    func getRatingCount(ratingCount: Int) -> String? {
            var ratingCountStr = ""
        if ratingCount < 1000 {
            ratingCountStr = String(ratingCount)
        } else if ratingCount < 10000 {
            ratingCountStr = String(format: "%.1f천", (Double(ratingCount) / 1000))
        } else {
            ratingCountStr = String(format: "%.1f만", (Double(ratingCount) / 10000).rounded())
        }
        
        ratingCountStr = ratingCountStr.replacingOccurrences(of: ".0", with: "")
        return ratingCountStr
    }
    
    func getUpdateDate(date: String) -> String? {
        var lastlyUpdateDate = date
        lastlyUpdateDate = lastlyUpdateDate.replacingOccurrences(of: "T", with: " ")
        lastlyUpdateDate = lastlyUpdateDate.replacingOccurrences(of: "Z", with: "")
        
        let dateString:String = lastlyUpdateDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date:Date = dateFormatter.date(from: dateString)!
        var interval = Date().timeIntervalSince(date)/60/60/24
        
        if interval >= 7 {
            interval /= 7
            return String(Int(interval)) + "주전"
        } else {
            if interval < 1 { interval=1 }
            return String(Int(interval)) + "일전"
        }
    }
}
