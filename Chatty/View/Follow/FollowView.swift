//
//  FollowView.swift
//  Chatty
//
//  Created by Hyeonho on 2023/06/11.
//

import SwiftUI

struct FollowView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var username : String
    var body: some View {
        VStack{
            navView
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}


extension FollowView {
    var navView : some View {
        HStack(spacing: 25){
            Button(action:{
                dismiss()
            }){
                Image(systemName: "arrow.left")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            Text(username)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal,24)
        .padding(.vertical,14)
    }
}

struct FollowView_Previews: PreviewProvider {
    static var previews: some View {
        FollowView(username: .constant("test11"))
    }
}
