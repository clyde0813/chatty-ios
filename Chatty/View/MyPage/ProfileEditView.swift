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
    @ObservedObject var profileVM : ProfileVM
    
    
    @State var username : String = ""
    @State var profile_name : String = ""
    
    @State var profile_message : String = ""
    
    @State private var selectedBackgroundImageItem: PhotosPickerItem?
    @State private var selectedBackgroundUIImage : UIImage?
    @State private var selectedBackgroundImage: Image?
    
    @State private var selectedProfileImageItem: PhotosPickerItem?
    @State private var selectedProfileUIImage : UIImage?
    @State private var selectedProfileImage: Image?
    
    
    @State private var usernameVerify : Bool = false
    
    @State private var usernameError : Bool = false
    
    @State private var profileEditProgress : Bool = false
    @State private var profileEditSuccess : Bool = false
    
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
                    if (self.username.isEmpty || self.usernameVerify) && self.profile_name.count <= 20 && self.profile_message.count < 50{
                        Button(action:{
                            self.profileEditProgress = true
                            
                            profileVM.profileEdit(username: username, profile_name: profile_name, profile_message: profile_message, profile_image: selectedProfileUIImage, background_image: selectedBackgroundUIImage)
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
                    ScrollView{
                        VStack(spacing: 0){
                            ZStack{
                                ZStack{
                                    if selectedBackgroundImage == nil{
                                        PhotosPicker(selection: $selectedBackgroundImageItem,
                                                     matching: .images,
                                                     photoLibrary: .shared()){
                                            KFImage(URL(string: profileVM.profileModel?.backgroundImage ?? ""))
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
                                ZStack{
                                    if selectedProfileImage == nil {
                                        PhotosPicker(selection: $selectedProfileImageItem,
                                                     matching: .images,
                                                     photoLibrary: .shared()){
                                            KFImage(URL(string: profileVM.profileModel?.profileImage ?? ""))
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
                                    TextField("\(profileVM.profileModel?.username ?? "")", text: $username)
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
                                TextField("\(profileVM.profileModel?.profile_name ?? "")", text: $profile_name)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.top, 32)
                            .padding([.leading, .trailing], 16)
                            
                            VStack(alignment: .leading,spacing: 8){
                                HStack{
                                    Text("자기소개")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color("Grey700"))
                                    Text("\(profile_message.count)/50")
                                        .font(.caption)
                                        .foregroundColor(profile_message.count <= 50 ? Color.black : Color.red)
                                    Spacer()
                                }
                                .padding(.leading, 5)
                                TextField("\(profileVM.profileModel?.profileMessage ?? "")", text: $profile_message,axis: .vertical)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                                Spacer()
                            }
                            .padding(.top, 32)
                            .padding([.leading, .trailing], 16)
                            .frame(height: 250)
                        }
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
                    
                    if self.profileEditProgress{
                        VStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                    
                    if self.profileEditSuccess{
                        VStack{
                            Spacer()
                            Text("수정이 완료되었습니다!")
                                .frame(width: 310, height: 40)
                                .foregroundColor(Color.white)
                                .background(Color("Error Background"))
                                .cornerRadius(16)
                                .padding(.bottom, 100)
                        }
                    }
                }
                .frame(width: proxy.size.width)
                .onTapGesture {
                    endEditing()
                }
            }
        }
        .navigationBarHidden(true)
        .onReceive(profileVM.profileEditSuccess) {
            profileVM.profileGet(username: KeyChain.read(key: "username")!)
            self.profileEditProgress = false
            self.profileEditSuccess = true
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                self.profileEditSuccess = false
            }
        }
    }
}

//struct ProfileEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileEditView().environmentObject(ChattyVM())
//    }
//}
