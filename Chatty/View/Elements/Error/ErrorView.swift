//
//  ErrorView.swift
//  Chatty
//
//  Created by Clyde on 2023/05/30.
//

import SwiftUI

struct ErrorView : View {
    @State var message : String
    init(message: String) {
        self.message = message
    }
    var body: some View{
        VStack{
            Spacer()
            Text(message)
                .frame(width: 310, height: 40)
                .foregroundColor(Color.white)
                .background(Color("Error Background"))
                .cornerRadius(16)
                .padding(.bottom, 100)
        }

    }
}
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "뭘봐 임마")
    }
}
