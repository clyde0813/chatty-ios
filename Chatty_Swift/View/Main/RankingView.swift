//
//  RankingView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/23.
//

import SwiftUI

struct RankingView: View {
    var body: some View {
        ScrollView {
            VStack{
                ZStack{
                    Color("Main Color")
                    VStack{
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color("Sub Color"))
                            .frame(height: 50)
                            .padding(.top, 60)
                            .padding(.bottom, -60)
                            .padding()
                        HStack{
                            VStack{
                                Circle()
                                    .fill(Color(.white))
                                    .frame(height: 80)
                                Text("정석호")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.white))
                                Text("131개")
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                                    .frame(width: 80, height: 28)
                                    .foregroundColor(Color(.white))
                                    .background(Color("Sub Color").opacity(0.2))
                                    .cornerRadius(16)
                            }
                            .padding(.top, 100)
                            VStack{
                                Circle()
                                    .fill(Color(.white))
                                    .frame(height: 105)
                                    .padding()
                                Text("정석호")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.white))
                                Text("131개")
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                                    .frame(width: 80, height: 28)
                                    .foregroundColor(Color(.white))
                                    .background(Color("Sub Color").opacity(0.2))
                                    .cornerRadius(16)
                            }
                            VStack{
                                Circle()
                                    .fill(Color(.white))
                                    .frame(height: 80)
                                Text("정석호")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.white))
                                Text("131개")
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                                    .frame(width: 80, height: 28)
                                    .foregroundColor(Color(.white))
                                    .background(Color("Sub Color").opacity(0.2))
                                    .cornerRadius(16)
                            }
                            .padding(.top, 100)
                        }
                        .padding()
                    }
                }
                .frame(height: 380)
                ZStack{
                    Color(.white)
                    VStack{
                        ForEach(0..<10) { i in
                            HStack{
                                Text("4")
                                Circle()
                                    .fill(Color(.black))
                                    .frame(width:50)
                                    .padding(.leading, 8)
                                Text("권진영")
                                    .font(.system(size:16))
                                    .fontWeight(.bold)
                                    .padding(.leading, 5)
                                Spacer()
                                Text("98개")
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                                    .frame(width: 70, height: 30)
                                    .foregroundColor(Color("Main Color"))
                                    .background(Color("Sub Color"))
                                    .cornerRadius(16)
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView()
    }
}

