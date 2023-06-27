//
//  SearchUserView.swift
//  Chatty
//
//  Created by Clyde on 2023/06/11.
//

import SwiftUI
import Combine
import Kingfisher

struct UserSearchView: View {
    @StateObject var userSearchVM = UserSearchVM()
    @StateObject var followVM = FollowVM()
    @StateObject var userSearchHistoryVM = UserSearchHistoryVM()
    
    @Environment(\.dismiss) private var dismiss
    
    @State var keyword: String = ""
    
    @State var currentPage : Int = 0
    
    var body: some View {
        GeometryReader{ proxy in
            ZStack(alignment: .bottomTrailing){
                VStack{
                    navBar
                        .background(Rectangle()
                            .fill(Color.white)
                            .shadow(color: Color("Shadow Button"), radius: 2, x: 0, y: 3)
                        )
                    resultArea
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color("Background inner"))
                }
                
            }
            .onTapGesture {
                endEditing()
            }
        }
        .navigationBarHidden(true)
    }
    
}

extension UserSearchView {
    var navBar : some View {
        HStack{
            Button(action:{
                dismiss()
            }){
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.black)
                    .padding(.trailing, 5)
            }
            TextField("검색어를 입력해주세요.", text: $userSearchVM.inputText)
                .font(Font.system(size: 16, weight: .none))
            Spacer()
            Button(action:{
                self.currentPage = 1
                userSearchVM.genericListModel = nil
                userSearchVM.userSearch(page: 1)
            }) {
                Image(systemName: "magnifyingglass")
                    .fontWeight(.semibold)
                    .font(.system(size: 28))
                    .foregroundColor(Color("Main Secondary"))
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 50)
        .onChange(of: userSearchVM.resultKeyword) { text in
            self.currentPage = 1
            userSearchVM.genericListModel = nil
            userSearchVM.userSearch(page: 1)
        }
//        .onChange(of: self.keyword) { data in
//            self.currentPage = 1
//            userSearchVM.genericListModel = nil
//            userSearchVM.userSearch(keyword: self.keyword, page: 1)
//        }
    }
    
    var resultArea : some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                
                //검색중일때
                if userSearchVM.resultKeyword.isEmpty {
                    VStack{
                        HStack(alignment: .center){
                            Text("최근 검색")
                                .font(Font.system(size: 20, weight: .semibold))
                            Spacer()
                            Button(action: {
                                userSearchHistoryVM.deleteAllSearches()
                            }){
                                Text("모두 지우기")
                                    .font(Font.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color("Orange Main"))
                            }
                        }
                        VStack(spacing: 25){
                            ForEach(userSearchHistoryVM.userSearchHistory.reversed(), id:\.keyword) { data in
                                HStack(spacing: 0){
                                    Button(action: {
                                        userSearchVM.inputText = data.keyword ?? ""
                                        userSearchVM.resultKeyword = data.keyword ?? ""
                                    }){
                                        Text("\(data.keyword ?? "")")
                                            .font(Font.system(size: 16, weight: .none))
                                        Spacer()
                                    }
                                    Button(action:{
                                        userSearchHistoryVM.deleteSearch(withKeyword: data.keyword ?? "")
                                    }){
                                        Image(systemName: "x.circle.fill")
                                            .fontWeight(.semibold)
                                            .font(.system(size: 20))
                                            .foregroundColor(Color("Grey600"))
                                    }
                                }
                            }
                        }
                        .padding(.top, 15)
                        .padding([.leading, .trailing], 5)
                    }
                    .frame(minHeight: 20)
                    .padding([.leading, .trailing], 24)
                    .padding([.top], 12)
//                } else if self.keyword.isEmpty && userSearchHistoryVM.userSearchHistory.isEmpty {
//                    EmptyView()
                }else if !userSearchVM.resultKeyword.isEmpty && userSearchVM.genericListModel?.results == nil {
                    ProgressView()
                }
                
                //검색완료되었을때
                else if let resultList = userSearchVM.genericListModel?.results {
                    ForEach(Array(zip(resultList.indices,resultList)), id:\.0) { index,data in
                        ZStack{
                            Color.white
                            HStack{
                                //profile image & ID + Profile Name Area
                                NavigationLink {
                                    ProfileView(username: .constant(data.username), isOwner: false)
                                } label: {
                                    HStack(spacing: 12){
                                        KFImage(URL(string:data.profileImage))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 48, height: 48)
                                            .clipShape(Circle())
                                            .clipped()
                                            .padding(.trailing, 8)
                                        VStack(alignment: .leading, spacing: 4){
                                            Text(data.profile_name)
                                                .font(Font.system(size: 14, weight: .semibold))
                                                .foregroundColor(Color.black)
                                            Text("@\(data.username)")
                                                .font(Font.system(size: 11, weight: .light))
                                                .foregroundColor(Color("Text Light Secondary"))
                                        }
                                    }
                                }
                                .simultaneousGesture(TapGesture().onEnded{
                                    userSearchHistoryVM.addSearch(keyword: userSearchVM.resultKeyword)
                                })
                                Spacer()
                                
                                if data.followState {
                                    Button(action: {
                                        followVM.followPost(username: data.username)
                                        userSearchVM.genericListModel?.results[index].followState.toggle()
                                    }){
                                        Text("팔로잉")
                                            .font(.system(size:14, weight: .bold))
                                            .frame(width: 45, height: 18)
                                            .foregroundColor(Color.white)
                                            .padding(.vertical,10)
                                            .padding(.horizontal)
                                            .background(
                                                Capsule()
                                                    .fill(Color("Grey300"))
                                            )
                                    }
                                } else {
                                    Button(action: {
                                        followVM.followPost(username: data.username)
                                        userSearchVM.genericListModel?.results[index].followState.toggle()
                                    }){
                                        Text("팔로우")
                                            .font(.system(size:14, weight: .bold))
                                            .frame(width: 45, height: 18)
                                            .foregroundColor(Color.white)
                                            .padding(.vertical,10)
                                            .padding(.horizontal)
                                            .background(
                                                Capsule()
                                                    .fill(Color("Pink Main"))
                                            )
                                    }
                                }
                                
                                //Follow button

                            }
                            .padding([.leading, .trailing], 16)
                            .padding([.top, .bottom], 12)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 72)
                        .mask(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color("Shadow Card"), radius: 3, x: 0, y: 7)
                        .padding([.leading, .trailing], 20)
                        .onAppear{
                            callNextRseult(data: data)
                        }
                        
                    }
                }
                
            }
            .padding(.top, 16)
        }
    }
    
    func callNextRseult(data: ProfileModel){
        print("callNextRseult() - run")
        if userSearchVM.genericListModel?.results.isEmpty == false && userSearchVM.genericListModel?.next != nil && data.username == userSearchVM.genericListModel?.results.last?.username{
            self.currentPage += 1
            userSearchVM.userSearch(page: self.currentPage)
        }
        
    }
}

struct UserSearchView_Previews: PreviewProvider {
    static var previews: some View {
        UserSearchView()
    }
}
