import SwiftUI
import Kingfisher

struct TimelineCard: View {
    
    var width : CGFloat
    
    @ObservedObject var timelineCardVM : TimeLineCardVM
    
    @State var optionShow = false
    
    init(width:CGFloat, chatty: ResultDetail){
        self.width = width
        self.timelineCardVM = TimeLineCardVM(chatty: chatty)
    }
    
    var body: some View {
        ZStack{
            Color.white
            VStack(alignment: .leading,spacing: 10){

                if timelineCardVM.chatty.author == nil{
                    NilQuestion
                }
                else{
                    NotNilQuestion
                }
                // 완료된 답변일시,
                answered
                bottomBar
            }
            .padding([.leading, .trailing, .bottom], 16)
            .padding(.top, 12)
        }
        .sheet(isPresented: $optionShow, onDismiss: {optionShow = false}) {
            QuestionOption(chatty: timelineCardVM.chatty)
                .presentationDetents(timelineCardVM.chatty.author?.username == KeyChain.read(key: "username") ? [.fraction(0.4)] : [.fraction(0.2)])
        }
        .frame(width: width)
        .frame(minHeight: 0)
        .fixedSize(horizontal: false, vertical: true)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color("Shadow Card"), radius: 3, x: 0, y: 7)
    }
}

extension TimelineCard {
    //익명일떄 질문양식
    var NilQuestion : some View {
        VStack(alignment: .leading, spacing: 5){
            HStack(spacing: 0){
                Text("From @")
                    .font(.system(size:12))
                    .foregroundColor(Color("Main Primary"))
                Text("익명")
                    .font(.system(size:12, weight: .bold))
                    .padding(.trailing, 8)
                    .foregroundColor(Color("Main Primary"))
                Text("•")
                    .font(Font.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.gray)
                    .padding(.trailing, 8)
                Text("\(elapsedtime(time: timelineCardVM.chatty.createdDate))")
                    .font(Font.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.gray)
                Spacer()
                Button(action : {
                    optionShow.toggle()
                }){
                    ZStack{
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                            .rotationEffect(.degrees(-90))
                            .font(Font.system(size: 16, weight: .bold))
                    }
                    .frame(width:20, height: 20)
                }
            }
            Text(timelineCardVM.chatty.content)
                .font(Font.system(size: 16, weight: .none))
                .padding(.trailing, 5)
        }
    }

    //익명이 아닐때 질문양식
    var NotNilQuestion : some View {
        HStack{
            NavigationLink(value: ShareLink.profileView(timelineCardVM.chatty.author?.username ?? "")) {
                KFImage(URL(string:"\(timelineCardVM.chatty.author?.profileImage ?? "")"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .overlay(Circle()
                        .stroke(Color.white, lineWidth: 3))
                    .clipped()
                    .padding(.trailing, 8)
            }
            
            VStack(alignment: .leading,spacing: 5){
                HStack(spacing: 4){
                    Text(timelineCardVM.chatty.author?.profileName ?? "")
                        .font(Font.system(size: 16, weight: .bold))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text("@\(timelineCardVM.chatty.author?.username ?? "")")
                        .font(Font.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text("\(elapsedtime(time: timelineCardVM.chatty.createdDate))")
                        .font(Font.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.gray)
                    Spacer()
                    Button(action : {
                        optionShow.toggle()
                    }){
                        ZStack{
                            Image(systemName: "ellipsis")
                                .foregroundColor(.black)
                                .rotationEffect(.degrees(-90))
                                .font(Font.system(size: 16, weight: .bold))
                        }
                        .frame(width:20, height: 20)
                    }
                }
                Text(timelineCardVM.chatty.content)
                    .font(Font.system(size: 16, weight: .none))
                    .padding(.trailing, 5)
            }
        }
        .padding(.bottom, 4)
    }

    //답변영역
    var answered : some View {
        HStack(alignment: .top, spacing: 0){
            //답변 표현 화살표
            Image(systemName: "arrow.turn.down.right")
                .foregroundColor(Color("Main Primary"))
                .fontWeight(.semibold)
                .font(Font.system(size: 16, weight: .bold))
                .padding([.top, .trailing], 4)
            //Profile 사진
            HStack(alignment: .top){
                
                NavigationLink(value: ShareLink.profileView(timelineCardVM.chatty.profile.username)) {
                    KFImage(URL(string:"\(timelineCardVM.chatty.profile.profileImage)"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .overlay(Circle()
                            .stroke(Color.white, lineWidth: 3))
                        .clipped()
                        .padding(.trailing, 8)
                }

                VStack(alignment: .leading,spacing: 8){
                    HStack(spacing: 4){
                        Text(timelineCardVM.chatty.profile.profileName)
                            .font(Font.system(size: 16, weight: .bold))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text("@\(timelineCardVM.chatty.profile.username)")
                            .font(Font.system(size: 12, weight: .semibold))
                            .foregroundColor(Color.gray)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text("\(elapsedtime(time: timelineCardVM.chatty.answeredDate ?? ""))")
                            .font(Font.system(size: 12, weight: .semibold))
                            .foregroundColor(Color.gray)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer()
                    }
                    Text(timelineCardVM.chatty.answerContent ?? "")
                        .font(Font.system(size: 16, weight: .none))
                        .padding(.trailing, 5)
                }
            }
        }
        .padding(.horizontal,5)
        .padding(.top,5)

    }

    //좋아요, 저장, 공유
    var bottomBar : some View {
        HStack(spacing: 0){
            Spacer()
            HStack(spacing: 3){
                Button {
                    timelineCardVM.likeChatty()
                } label: {
                    if timelineCardVM.chatty.likeStatus {
                        Image(systemName: "heart.fill")
                            .fontWeight(.semibold)
                            .font(Font.system(size: 16, weight: .bold))
                            .foregroundColor(.red)
                    }else {
                        Image(systemName: "heart")
                            .fontWeight(.semibold)
                            .font(Font.system(size: 16, weight: .bold))
                    }
                }
                Text("\(timelineCardVM.chatty.like)")
                    .font(Font.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("Text Light Primary"))
            }
            .frame(width: (width-32) / 2)

//                    Button {
//                        print("bookMark!!")
//                    } label: {
//                        Image(systemName: "bookmark")
//                            .fontWeight(.semibold)
//                            .font(Font.system(size: 16, weight: .bold))
//                            .frame(width: (width-32) / 3)
//                    }


            Button {
                //MARK: -  상위뷰에 복사완료이벤트 전달해야함.
                UIPasteboard.general.string = "chatty.kr/\(timelineCardVM.chatty.profile.username)"
                ChattyEventManager.share.showAlter.send("복사완료!")
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .fontWeight(.semibold)
                    .font(Font.system(size: 16, weight: .bold))
                    .frame(width: (width-32) / 2)
            }


        }
    }
}
