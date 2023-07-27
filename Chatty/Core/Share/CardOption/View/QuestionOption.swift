import SwiftUI

struct QuestionOption: View {
    @Environment(\.dismiss) var dismiss
    
    @State var isSaveImage = false
    
    @ObservedObject var viewmodel : QuestionOptionVM
    
    init(chatty: ResultDetail) {
        viewmodel = QuestionOptionVM(chatty: chatty)
    }
    
    @State private var timer: Timer? = nil
    
    var body: some View {
        ZStack{
            Color.white
            VStack(alignment: .leading, spacing: 16){
                HStack(spacing: 0){
                    Text("이 질문을...")
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

                if  viewmodel.chatty.profile.username == KeyChain.read(key: "username") {
                    Button(action: {
                        isSaveImage = true
                    }){
                        HStack(spacing: 8){
                            Image(systemName: "photo.fill")
                                .font(Font.system(size: 16, weight: .bold))
                            Text("이미지 저장")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .frame(height: 60)
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity
                        )
                        .foregroundColor(Color.white)
                        .background(Color("Main Primary"))
                        .cornerRadius(16)
                    }
                    .fullScreenCover(isPresented: $isSaveImage){
                        ChattyShareView(chatty: viewmodel.chatty)
                    }
                    
                    Button(action:{
                        dismiss()
                        viewmodel.questionReport()
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
                    
                    Button(action:{
                        dismiss()
                        viewmodel.questionDelete()
                    }){
                        
                        HStack(spacing: 8){
                            Image(systemName: "trash.fill")
                                .font(Font.system(size: 16, weight: .bold))
                            Text("삭제하기")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .frame(height: 60)
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity
                        )
                        .foregroundColor(Color.white)
                        .background(Color("Grey900"))
                        .cornerRadius(16)
                    }
                    
                }
                
                else{
                    Button(action:{
                        dismiss()
                        viewmodel.questionReport()
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
                    .clipped()
                }
            }
            .clipped()
            .padding(20)
        }
//        ZStack{
//            Color.white
//            VStack(alignment: .leading, spacing: 16){
//                HStack(spacing: 0){
//                    Text("이 질문을...")
//                        .font(.system(size: 20, weight: .bold))
//                    Spacer()
//                    Button(action: {
//                        dismiss()
//                    }){
//                        Image(systemName: "xmark")
//                            .foregroundColor(Color.black)
//                            .fontWeight(.semibold)
//                            .font(Font.system(size: 16, weight: .bold))
//                    }
//                }
//
//
//                if viewmodel.chatty.profile.username == KeyChain.read(key: "username") || viewmodel.chatty.author?.username == KeyChain.read(key: "username"){
//                    Button(action: {
//                        isSaveImage = true
//                    }){
//                        HStack(spacing: 8){
//                            Image(systemName: "photo.fill")
//                                .font(Font.system(size: 16, weight: .bold))
//                            Text("이미지 저장")
//                                .font(.system(size: 16, weight: .bold))
//                        }
//                        .frame(height: 60)
//                        .frame(
//                            minWidth: 0,
//                            maxWidth: .infinity
//                        )
//                        .foregroundColor(Color.white)
//                        .background(Color("Main Primary"))
//                        .cornerRadius(16)
//                    }
//                    .fullScreenCover(isPresented: $isSaveImage){
//                        ChattyShareView(chatty: viewmodel.chatty)
//                    }
//
//                    Button(action:{
//                        dismiss()
//                        viewmodel.questionReport()
//                    }){
//                        HStack(spacing: 8){
//                            Image(systemName: "light.beacon.max")
//                                .font(Font.system(size: 16, weight: .bold))
//                            Text("신고 & 차단하기")
//                                .font(.system(size: 16, weight: .bold))
//                        }
//                        .frame(height: 60)
//                        .frame(
//                            minWidth: 0,
//                            maxWidth: .infinity
//                        )
//                        .foregroundColor(Color("Pink Dark"))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 16)
//                                .stroke(Color("Pink Dark"), lineWidth: 2)
//                        )
//                    }
//                    .padding([.leading, .trailing, .bottom], 3)
//
//                    Button(action:{
//                        dismiss()
//                        viewmodel.questionDelete()
//                    }){
//
//                        HStack(spacing: 8){
//                            Image(systemName: "trash.fill")
//                                .font(Font.system(size: 16, weight: .bold))
//                            Text("삭제하기")
//                                .font(.system(size: 16, weight: .bold))
//                        }
//                        .frame(height: 60)
//                        .frame(
//                            minWidth: 0,
//                            maxWidth: .infinity
//                        )
//                        .foregroundColor(Color.white)
//                        .background(Color("Grey900"))
//                        .cornerRadius(16)
//                    }
//
//                }
//                else{
//                    Button(action:{
//                        dismiss()
//                        viewmodel.questionReport()
//                    }){
//                        HStack(spacing: 8){
//                            Image(systemName: "light.beacon.max")
//                                .font(Font.system(size: 16, weight: .bold))
//                            Text("신고 & 차단하기")
//                                .font(.system(size: 16, weight: .bold))
//                        }
//                        .frame(height: 60)
//                        .frame(
//                            minWidth: 0,
//                            maxWidth: .infinity
//                        )
//                        .foregroundColor(Color("Pink Dark"))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 16)
//                                .stroke(Color("Pink Dark"), lineWidth: 2)
//                        )
//                    }
//                    .padding([.leading, .trailing, .bottom], 3)
//                    .clipped()
//                }
//            }
//            .clipped()
//            .padding(20)
//        }
    }

}

