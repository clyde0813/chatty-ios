//
//  ProfileEditView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/23.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct ProfileEditView: View {
    @EnvironmentObject var chattyVM: ChattyVM
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var username : String = ""
    @State var profile_name : String = ""
    
    @State var profile_message : String = ""
    @State var backgroundImage : String = ""
    
    @State private var selectedBackgroundImageItem: PhotosPickerItem?
    @State private var selectedBackgroundUIImage : UIImage?
    @State private var selectedBackgroundImage: Image?
    
    @State private var selectedProfileImageItem: PhotosPickerItem?
    @State private var selectedProfileUIImage : UIImage?
    @State private var selectedProfileImage: Image?
    
    
    @State private var usernameVerify : Bool = false
    
    @State private var usernameError : Bool = false
    
    var body: some View {
        GeometryReader{ proxy in
            VStack(spacing: 0){
                HStack{
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.black)
                            .padding(.trailing, 20)
                        Text("프로필 수정")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.black)
                    }
                    Spacer()
                    if self.username.isEmpty || self.usernameVerify{
                        Button(action:{
                            chattyVM.profileEdit(username: username, profile_name: profile_name, profile_message: profile_message, profile_image: selectedProfileUIImage, background_image: selectedBackgroundUIImage)
                        }){
                            Text("저장하기")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.black)
                        }
                    } else {
                        Text("저장하기")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color("Grey200"))
                    }
                }
                .padding([.leading, .trailing], 16)
                .zIndex(1)
                .frame(height: 50)
                ZStack(alignment: .top){
                    Color.white
                    VStack(spacing: 0){
                        ZStack{
                            //                            KFImage(URL(string: "\(chattyVM.profileModel?.backgroundImage ?? "")"))
                            ZStack{
                                if selectedBackgroundImage == nil{
                                    PhotosPicker(selection: $selectedBackgroundImageItem,
                                                 matching: .images,
                                                 photoLibrary: .shared()){
                                        KFImage(URL(string : "https://chatty-s3-dev.s3.ap-northeast-2.amazonaws.com/default_background.png"))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width:proxy.size.width, height: 160)
                                            .clipped()
                                    }
                                                 .onChange(of: selectedBackgroundImageItem) { newItem in
                                                     Task {
                                                         if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                                             selectedBackgroundUIImage = UIImage(data: data)
                                                             selectedBackgroundImage = Image(uiImage: selectedBackgroundUIImage!)
                                                         }
                                                     }
                                                 }
                                } else {
                                    PhotosPicker(selection: $selectedBackgroundImageItem,
                                                 matching: .images,
                                                 photoLibrary: .shared()){
                                        selectedBackgroundImage!
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width:proxy.size.width, height: 160)
                                            .clipped()
                                    }
                                                 .onChange(of: selectedBackgroundImageItem) { newItem in
                                                     Task {
                                                         if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                                             selectedBackgroundUIImage = UIImage(data: data)
                                                             selectedBackgroundImage = Image(uiImage: selectedBackgroundUIImage!)
                                                         }
                                                     }
                                                 }
                                }
                                Image("ImagePicker")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 20, height: 20)
                            }
                            //                            KFImage(URL(string: "\(chattyVM.profileModel?.profileImage ?? "")"))
                            ZStack{
                                if selectedProfileImage == nil {
                                    PhotosPicker(selection: $selectedProfileImageItem,
                                                 matching: .images,
                                                 photoLibrary: .shared()){
                                        KFImage(URL(string: "https://chatty-s3-dev.s3.ap-northeast-2.amazonaws.com/default.png"))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 110, height: 110)
                                            .clipShape(Circle())
                                    }
                                                 .onChange(of: selectedProfileImageItem) { newItem in
                                                     Task {
                                                         if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                                             selectedProfileUIImage = UIImage(data: data)
                                                             selectedProfileImage = Image(uiImage: selectedProfileUIImage!)
                                                         }
                                                     }
                                                 }
                                } else {
                                    PhotosPicker(selection: $selectedProfileImageItem,
                                                 matching: .images,
                                                 photoLibrary: .shared()){
                                        selectedProfileImage!
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 110, height: 110)
                                            .clipShape(Circle())
                                    }
                                                 .onChange(of: selectedProfileImageItem) { newItem in
                                                     Task {
                                                         if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                                             selectedProfileUIImage = UIImage(data: data)
                                                             selectedProfileImage = Image(uiImage: selectedProfileUIImage!)
                                                         }
                                                     }
                                                 }
                                }
                                Image("ImagePicker")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 20, height: 20)
                                    .offset(x: -2.5, y: -3)
                                
                            }
                            .offset(x: -(proxy.size.width / 2) + 75, y: 75)
                        }
                        
                        VStack(spacing: 8){
                            HStack{
                                Text("아이디")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color("Grey700"))
                                Spacer()
                            }
                            .padding(.leading, 5)
                            ZStack(alignment: .trailing){
                                TextField("아이디 4글자 이상 20글자 이하", text: $username)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                                Button(action: {
                                    chattyVM.verifyUsername(username: username)
                                }){
                                    if usernameVerify {
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.system(size:13, weight: .semibold))
                                            .frame(width: 60, height: 15)
                                            .foregroundColor(Color.white)
                                            .padding(.vertical,10)
                                            .padding(.horizontal)
                                            .background(
                                                Capsule()
                                                    .fill(Color("Pink Main"))
                                            )
                                            .padding(.trailing, 16)
                                    } else {
                                        Text("중복확인")
                                            .font(.system(size:13, weight: .semibold))
                                            .frame(width: 60, height: 15)
                                            .foregroundColor(Color.white)
                                            .padding(.vertical,10)
                                            .padding(.horizontal)
                                            .background(
                                                Capsule()
                                                    .fill(Color("Pink Main"))
                                            )
                                            .padding(.trailing, 16)
                                    }
                                }
                                .onReceive(chattyVM.usernameAvailable){
                                    usernameVerify.toggle()
                                }
                                .onReceive(chattyVM.usernameUnavailable){
                                    self.usernameError = true
                                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                                        self.usernameError = false
                                    }
                                }
                                .disabled(usernameVerify || self.username.isEmpty || self.username.count < 4 || self.username.count > 15)
                            }
                        }
                        .padding(.top, 70)
                        .padding([.leading, .trailing], 16)
                        
                        VStack(spacing: 8){
                            HStack{
                                Text("닉네임")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color("Grey700"))
                                Spacer()
                            }
                            .padding(.leading, 5)
                            TextField("닉네임 1글자 이상 20글자 이하", text: $profile_name)
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .mask(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.top, 32)
                        .padding([.leading, .trailing], 16)
                        
                        VStack(spacing: 8){
                            HStack{
                                Text("자기소개")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color("Grey700"))
                                Spacer()
                            }
                            .padding(.leading, 5)
                            TextField("bio", text: $profile_message)
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .mask(RoundedRectangle(cornerRadius: 16))
                            Spacer()
                        }
                        .padding(.top, 32)
                        .padding([.leading, .trailing], 16)
                        .frame(height: 250)
                    }
                    
                    if self.usernameError{
                        VStack{
                            Spacer()
                            Text("사용 불가능한 아이디입니다.")
                                .frame(width: 310, height: 40)
                                .foregroundColor(Color.white)
                                .background(Color("Error Background"))
                                .cornerRadius(16)
                                .padding(.bottom, 30)
                        }
                    }
                }
                .frame(width: proxy.size.width)
                .onTapGesture {
                    endEditing()
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .navigationBarHidden(true)
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView().environmentObject(ChattyVM())
    }
}
