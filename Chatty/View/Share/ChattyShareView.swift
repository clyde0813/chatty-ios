//
//  ChattyCardShareView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/18.
//

import SwiftUI
import Kingfisher

struct ChattyShareView: View {
    @StateObject var chattyVM = ChattyVM()
    @ObservedObject var eventVM : ChattyEventVM
    @Environment(\.presentationMode) var presentationMode
        
//    @Binding var username : String
//
//    @Binding var profile_name : String
//
//    @Binding var profile_image : String
//
//    @Binding var background_image : String
//
//    @Binding var questiondata : ResultDetail?
    
//    var username : String
//
//    var profile_name : String
//
//    var profile_image : String
//
//    var background_image : String
//
//    var content : String
//
//    var anseredContent : String
    
    @State private var hideButton = false
    
    @State var doScreenShot = false
            
    var body: some View {
        GeometryReader{ proxy in
            ZStack(alignment: .bottom){
                ZStack(alignment: .bottom){
                    KFImage(URL(string: "\(eventVM.data?.profile.backgroundImage ?? "")"))
                        .resizable()
                        .scaledToFill()
                        .padding(-30)
                        .blur(radius: 20)
                    VStack(spacing: 0){
                        Spacer()
                        // 카드
                        ZStack{
                            Color("Card Share Background")
                            VStack(alignment: .leading, spacing: 0){
                                if eventVM.data?.author == nil {
                                    HStack(spacing: 0){
                                        Text("To ")
                                            .font(Font.system(size: 12, weight: .semibold))
                                        Text("@\(eventVM.data?.profile.username ?? "")")
                                            .font(Font.system(size: 12, weight: .bold))
                                        Spacer()
                                    }
                                    .padding(.bottom, 4)
                                    
                                    Text(eventVM.data?.content ?? "")
                                        .font(Font.system(size: 16, weight: .semibold))
                                        .padding(.bottom, 24)
                                }else{
                                    HStack{
                                        KFImage(URL(string:eventVM.data?.author?.profileImage ?? ""))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 45, height: 45)
                                                .clipShape(Circle())
                                                .clipped()
                                                .padding(.trailing, 8)
                                        
                                        VStack(alignment: .leading, spacing: 0){
                                            HStack(spacing: 4){
                                                Text(eventVM.data?.author?.profileName ?? "")
                                                    .font(.system(size:12, weight: .bold))
                                                Text("@\(eventVM.data?.author?.username ?? "")")
                                                    .font(Font.system(size: 12, weight: .semibold))
                                                Spacer()
                                            }
                                            .padding(.bottom, 4)
                                            Text(eventVM.data?.content ?? "")
                                                .font(Font.system(size: 16, weight: .semibold))
                                                .padding(.bottom, 24)
                                        }
                                    }
                                    .padding(.bottom,8)
                                }
                                
                                
                                
                                HStack(alignment: .top, spacing: 0){
                                    //답변 표현 화살표
                                    Image(systemName: "arrow.turn.down.right")
                                        .fontWeight(.semibold)
                                        .font(Font.system(size: 16, weight: .bold))
                                        .padding(.top, 4)
                                        .padding(.trailing, 12)
                                    //Profile 사진
                                    KFImage(URL(string: "\(eventVM.data?.profile.profileImage ?? "")"))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipShape(Circle())
                                        .clipped()
                                        .padding(.trailing, 8)
                                    VStack(alignment: .leading, spacing: 0){
                                        HStack(spacing: 4){
                                            Text("\(eventVM.data?.profile.profileName ?? "")")
                                                .font(Font.system(size: 16, weight: .bold))
                                        }
                                        .padding(.bottom, 8)
                                        Text(eventVM.data?.answerContent ?? "")
                                            .font(Font.system(size: 16, weight: .none))
                                    }
                                }
                            }
                            .foregroundColor(Color.white)
                            .padding([.leading, .trailing], 24)
                            .padding([.top, .bottom], 32)
                        }
                        .frame(minHeight: 170)
                        .fixedSize(horizontal: false, vertical: true)
                        .mask(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color("Shadow Card"), radius: 3, x: 0, y: 7)
                        .padding(.bottom, 16)
                        HStack(spacing: 0){
                            Spacer()
                            Image("Card Share Logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 111, height: 29)
                        }
                        .padding(.trailing, 12)
                        Spacer()
                    }
                    .frame(width: proxy.size.width-40, height: proxy.size.height)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                if self.hideButton {
                    EmptyView()
                } else {
                    VStack(spacing:0){
                        HStack(spacing: 0) {
                            Button(action:{
                                chattyVM.questionOptionStatus = false
                                eventVM.mySheetPublisher.send()
                                presentationMode.wrappedValue.dismiss()
                            }){
                                Image(systemName: "arrow.left")
                                    .font(.system(size:18, weight: .bold))
                                    .foregroundColor(Color.white)
                                    .background(
                                        Circle()
                                            .fill(Color("Card Share Background"))
                                            .frame(width: 32, height: 32)
                                    )
                            }
                            Spacer()
                        }
                        .padding(.leading, 30)
                        .padding(.top, 60)
                        Spacer()
                    }
                    HStack(spacing:0){
                        Spacer()
                        VStack(alignment: .trailing,spacing: 16){
//                            Text("공유")
//                                .font(.system(size:16, weight: .semibold))
//                                .frame(width: 60, height: 25)
//                                .foregroundColor(Color.white)
//                                .padding(.vertical,10)
//                                .padding(.horizontal)
//                                .background(
//                                    Capsule()
//                                        .fill(Color("Card Share Background"))
//                                )
                            Button(action: {
                                self.hideButton = true
                            }){
                                Text("이미지로 저장")
                                    .font(.system(size:16, weight: .semibold))
                                    .frame(width: 100, height: 25)
                                    .foregroundColor(Color.white)
                                    .padding(.vertical,10)
                                    .padding(.horizontal)
                                    .background(
                                        Capsule()
                                            .fill(Color("Card Share Background"))
                                    )
                            }
                        }
                        .padding(.trailing, 20)
                    }
                    .frame(width: proxy.size.width)
                    .padding(.bottom, 40)
                    .onDisappear{
                        if self.hideButton{
                            saveScreenshot()
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.all)
    }
    
    func saveScreenshot() {
//            let image = UIApplication.shared.windows.first?.rootViewController?.view.asImage()
//            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
//            self.hideButton = false
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                  let frontViewController = keyWindow.frontViewController,
                  let frontView = frontViewController.view else {
                return
            }
            
            let image = frontView.asImage()
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.hideButton = false
    }
}
extension UIWindow {
    var frontViewController: UIViewController? {
        return self.windowScene?.frontMostUIWindowViewController
    }
}

extension UIWindowScene {
    var frontMostUIWindowViewController: UIViewController? {
        return self.windows.first { $0.isKeyWindow }?.rootViewController?.frontMostViewController
    }
}

extension UIViewController {
    var frontMostViewController: UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.frontMostViewController
        }
        
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.frontMostViewController ?? self
        }
        
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.frontMostViewController ?? self
        }
        
        return self
    }
}

extension UIView {
    func asImage() -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size, format: format)
        return renderer.image { _ in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }
}
//
//struct ChattyShareView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChattyShareView(username: "박똘추", profile_name: "박똘추",  profile_image: "https://chatty-s3-dev.s3.ap-northeast-2.amazonaws.com/default.png",  questiondata: ResultDetail(pk: 0, content: "얌마 또 치돈먹냐 돼지야", createdDate: "", answerContent: "으..응"))
//    }
//}
