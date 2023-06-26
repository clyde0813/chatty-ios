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
    let convertDate = dateFormatter.date(from: time)
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    let relativeDate = formatter.localizedString(for: convertDate ?? Date(), relativeTo: Date())
    return relativeDate
}
