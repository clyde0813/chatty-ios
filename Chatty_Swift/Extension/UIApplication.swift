//
//  UIApplication.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/03/01.
//

import Foundation

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
