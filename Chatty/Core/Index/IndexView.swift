import SwiftUI

struct IndexView: View {

    var body: some View {
        NavigationView {
            GeometryReader{ proxy in
                ZStack{
                    Color.white
                    VStack(spacing:0){
                        VStack(alignment: .leading, spacing: 16){
                            Text("안녕!")
                                .font(.system(size: 32, weight: .heavy))
                                .foregroundColor(Color("Main Primary"))
                            Text("자유로운 우리를 봐,")
                                .font(.system(size: 32, weight: .heavy))
                                .foregroundColor(Color("Pink Main"))
                            HStack(spacing: 0){
                                Text("Chatty ")
                                    .font(.custom("SUIT-Heavy", size: 32))
                                    .foregroundColor(Color("Main Primary"))
                                Text("예요!")
                                    .font(.system(size: 32, weight: .heavy))
                                    .foregroundColor(Color("Pink Main"))
                                Spacer()
                            }
                        }
                        .padding(.top, 116)
                        .padding(.leading, 30)
                        Spacer()
                        VStack(spacing: 0){
                            NavigationLink {
                                LoginView()
                            } label: {
                                HStack(spacing: 0){
                                    Text("Chatty ")
                                        .font(.custom("SUIT-Heavy", size: 16))
                                    Text("로그인")
                                        .font(.system(size: 16, weight: .heavy))
                                }
                                .frame(height: 60)
                                .frame(
                                    minWidth: 0,
                                    maxWidth: .infinity
                                )
                                .foregroundColor(Color.white)
                                .background(Color("Main Primary"))
                                .cornerRadius(6)
                            }
                            .padding(.bottom, 16)
                            
                            Text("앗, 회원이 아니라면?")
                                .font(.system(size: 16, weight: .none))
                                .padding(.bottom, 8)
                            
                            NavigationLink {
                                RegisterView()
                            } label: {
                                Text("박박 빠르게 회원가입하기 →")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color("Main Primary"))
                            }
                        }
                        .padding([.leading, .trailing], 16)
                        .padding(.bottom, 60)
                    }
                }
                .ignoresSafeArea(.all)
            }
            .toolbar(.hidden)
        }
        
    }
}

struct IndexView_Previews: PreviewProvider {
    static var previews: some View {
        IndexView()
    }
}
