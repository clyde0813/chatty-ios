//
//  TextExtensions.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/03/01.
//

import Foundation
import SwiftUI

func endEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
}

