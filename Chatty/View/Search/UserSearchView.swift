//
//  SearchUserView.swift
//  Chatty
//
//  Created by Clyde on 2023/06/11.
//

import SwiftUI
import Kingfisher

struct SearchUserView: View {
    @StateObject var searchUserVM = SearchUserVM()
    
    @State var keyword: String = ""
    
    var body: some View {
        GeometryReader{ proxy in
            ZStack(alignment: .bottomTrailing){
                VStack{
                    navBar
                    resultArea
                        .frame(width: proxy.size.width, height: proxy.size.height - 60)
                        .background(Color("Background inner"))
                }
            }
        }
    }
    
}

extension SearchUserView {
    var navBar : some View {
        HStack{
            TextField("검색어를 입력해주세요.", text: $keyword)
                .font(Font.system(size: 16, weight: .semibold))
            Spacer()
            Image(systemName: "magnifyingglass")
                .fontWeight(.semibold)
                .font(.system(size: 32))
                .foregroundColor(Color("Main Secondary"))
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
    }
    
    var resultArea : some View {
        VStack{
            ZStack{
                Color.white
                HStack{
                    //profile image & ID + Profile Name Area
                    HStack(spacing: 12){
                        KFImage(URL(string:"https://www.tclf.org/sites/default/files/microsites/raleigh2018/images/portfolio/geuze_headshot.jpg"))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                            .clipped()
                            .padding(.trailing, 8)
                        VStack(alignment: .center, spacing: 4){
                            Text("푸바오")
                                .font(Font.system(size: 14, weight: .semibold))
                            Text("@rre_1102")
                                .font(Font.system(size: 11, weight: .light))
                                .foregroundColor(Color("Text Light Secondary"))
                        }
                    }
                    
                    //Follow button
                    
                }
                .padding([.leading, .trailing], 16)
                .padding([.top, .bottom], 12)
            }
            .frame(width: .infinity, height: 72)
            .mask(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color("Shadow Card"), radius: 3, x: 0, y: 7)
            .padding([.leading, .trailing], 20)
        }
    }
}

struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView()
    }
}
