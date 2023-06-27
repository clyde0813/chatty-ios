//
//  TimeExtension.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/03/26.
//

import Foundation

func elapsedtime(time: String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    guard let convertDate = dateFormatter.date(from: time) else {return "알수없음"}
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    let relativeDate = formatter.localizedString(for: convertDate, relativeTo: Date())
    return relativeDate
}

func elapsedtime_Answer(time: String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    guard let convertDate = dateFormatter.date(from: time) else {return "알수없음"}
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    let relativeDate = formatter.localizedString(for: convertDate, relativeTo: Date())
    return relativeDate
}
