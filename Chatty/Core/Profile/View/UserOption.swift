//
//  UserOption.swift
//  Chatty
//
//  Created by Hyeonho on 2023/06/20.
//

import SwiftUI

struct UserOption: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var userOptionVM : UserOptionVM
    
    init(user:ProfileModel){
        self.userOptionVM = UserOptionVM(user:user)
    }
    
    var body: some View {
        ZStack{
            Color.white
            VStack(alignment: .leading, spacing: 16){
                HStack(spacing: 0){
                    Text("이 사용자를...")
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "xmark")
                            .foregroundColor(Color.black)
                            .fontWeight(.semibold)
                            .font(Font.system(size: 16, weight: .bold))
                    }
                }
                
                Button(action:{
                    dismiss()
                    userOptionVM.userBlock()
                }){
                    HStack(spacing: 8){
                        Image(systemName: "light.beacon.max")
                            .font(Font.system(size: 16, weight: .bold))
                        Text("신고 & 차단하기")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .frame(height: 60)
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity
                    )
                    .foregroundColor(Color("Pink Dark"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color("Pink Dark"), lineWidth: 2)
                    )
                }
                .padding([.leading, .trailing, .bottom], 3)
                
            }
            .clipped()
            .padding(20)
        }
    }
}
//
//struct UserOption_Previews: PreviewProvider {
//    static var previews: some View {
//        UserOption()
//    }
//}
