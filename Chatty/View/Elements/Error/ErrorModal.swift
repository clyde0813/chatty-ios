//
//  ErrorModal.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/24.
//

import SwiftUI

struct ErrorModal: View {
    @State var error_message : String = ""
    var body: some View {
        Text("\(error_message)")
    }
}

struct ErrorModal_Previews: PreviewProvider {
    static var previews: some View {
        ErrorModal(error_message: "사용 불가능한 아이디입니다.")
    }
}
