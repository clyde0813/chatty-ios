import SwiftUI
import PhotosUI
import Kingfisher

struct ProfileEditView: View {

    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewmodel = ProfileEditVM()
    
    @State var msg = ""
    @State var showMsg = false
    
    @State private var selectedBackgroundImageItem: PhotosPickerItem?
    @State private var selectedBackgroundUIImage : UIImage?
    @State private var selectedBackgroundImage: Image?
    
    @State private var selectedProfileImageItem: PhotosPickerItem?
    @State private var selectedProfileUIImage : UIImage?
    @State private var selectedProfileImage: Image?
    
    
    
    
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
                    if viewmodel.checkAailableEdit() {
                        Button(action:{
                            viewmodel.profileEdit(profile_image: selectedProfileUIImage, background_image: selectedBackgroundUIImage)
                        }){
                            Text("저장하기")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.black)
                        }
                    }
                    else {
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
                            
                            //MARK: - 배경이미지, 프로필이미지 변경하는곳
                            ZStack{
                                //배경이미지
                                ZStack{
                                    if selectedBackgroundImage == nil{
                                        PhotosPicker(selection: $selectedBackgroundImageItem,
                                                     matching: .images,
                                                     photoLibrary: .shared()){
                                            KFImage(URL(string: viewmodel.currentUser?.backgroundImage ?? ""))
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
                                    else {
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
                                
                                //프로필이미지
                                ZStack{
                                    if selectedProfileImage == nil {
                                        PhotosPicker(selection: $selectedProfileImageItem,
                                                     matching: .images,
                                                     photoLibrary: .shared()){
                                            KFImage(URL(string: viewmodel.currentUser?.profileImage ?? ""))
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
                                    else {
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
                                    
                                    
                                    TextField("", text: $viewmodel.username.toUnwrapped(defaultValue: ""))
                                        .padding()
                                        .background(Color(uiColor: .secondarySystemBackground))
                                        .mask(RoundedRectangle(cornerRadius: 16))
                                    Button(action: {
                                        viewmodel.verifyUsername()
                                    }){
                                        if viewmodel.usernameVerify {
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
                                    .disabled(viewmodel.checkAvailableUserNameButton())
                                }
                            }
                            .padding(.top, 70)
                            .padding([.leading, .trailing], 16)
                            
                            //MARK: - 닉네임
                            VStack(spacing: 8){
                                HStack{
                                    Text("닉네임")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color("Grey700"))
                                    Spacer()
                                }
                                .padding(.leading, 5)
                                TextField("", text: $viewmodel.profile_name.toUnwrapped(defaultValue: ""))
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.top, 32)
                            .padding([.leading, .trailing], 16)
                            
                            
                            VStack(spacing: 8){
                                HStack{
                                    Text("링크")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color("Grey700"))
                                    Spacer()
                                }
                                .padding(.leading, 5)
                                
                                TextField("", text: $viewmodel.urlString.toUnwrapped(defaultValue: ""))
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.top, 32)
                            .padding([.leading, .trailing], 16)
                            
                            //MARK: - 자기소개
                            VStack(alignment: .leading,spacing: 8){
                                HStack{
                                    Text("자기소개")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color("Grey700"))
                                    Text("\(viewmodel.profile_message?.count ?? 0)/50")
                                        .font(.caption)
                                        .foregroundColor(viewmodel.profile_message?.count ?? 0 <= 50 ? Color.black : Color.red)
                                    Spacer()
                                }
                                .padding(.leading, 5)
                                TextField("\(viewmodel.currentUser?.profileMessage ?? "")", text: $viewmodel.profile_message.toUnwrapped(defaultValue: ""),axis: .vertical)
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
                    
                    if viewmodel.isLoading {
                        VStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                    if showMsg {
                        ProfileEditErrorView(msg: msg)
                    }

                }
                .frame(width: proxy.size.width)
                .onTapGesture {
                    endEditing()
                }
            }
        }
        .navigationBarHidden(true)
        .onReceive(ChattyEventManager.share.showAlter){ result in
            msg = result
            showMsg = true
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                showMsg = false
            }
        }
        
    }
}

struct ProfileEditErrorView : View {
    let msg : String
    
    var body : some View {
        VStack{
            Spacer()
            Text(msg)
                .frame(width: 310, height: 40)
                .foregroundColor(Color.white)
                .background(Color("Error Background"))
                .cornerRadius(16)
                .padding(.bottom, 30)
        }
    }
}
