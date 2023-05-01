//
//  IntExtensions.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/20.
//

import Foundation

extension Int {
    func abbreviateNumber() -> String {
        var num: Double = Double(self)
        let sign = ((num < 0) ? "-" : "" )
        num = fabs(num)
        if num < 1000.0 {
            return "\(sign)\(Int(num))"
        }
        let exp: Int = Int(log10(num) / 3.0)
        let units: [String] = ["K", "M", "B"]
        let roundedNum: Double = round(10 * num / pow(1000.0, Double(exp))) / 10
        return "\(sign)\(roundedNum)\(units[exp-1])"
    }
}
