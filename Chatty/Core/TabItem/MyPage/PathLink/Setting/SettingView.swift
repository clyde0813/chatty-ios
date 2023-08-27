//
//  SettingView.swift
//  Chatty
//
//  Created by Hyeonho on 2023/08/02.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var isToggle = false
    
    @ObservedObject var viewmodel : SettingVM
    
    init(toggleState : Bool) {
        self.viewmodel = SettingVM(toggleState: toggleState)
    }
    
    
    var body: some View {
        VStack{
            navView
                .background(Rectangle()
                    .fill(Color.white)
                    .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 3)
                )
            
            Toggle(isOn: $viewmodel.toggleState){
                HStack{
                    Text("랭킹 활성화")
                    Image(systemName: "trophy")
                }
            }
            .foregroundColor(Color("Grey900"))
            .tint(Color("Orange Main"))
            .padding(.horizontal,10)
            .padding(.top,20)
            .onChange(of: viewmodel.toggleState) { newValue in
                viewmodel.rankingToggle()
            }
            
            
            
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(toggleState: false)
    }
}

extension SettingView {
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
            Text("환경설정")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal,24)
        .padding(.vertical,14)
    }
    
    
}
