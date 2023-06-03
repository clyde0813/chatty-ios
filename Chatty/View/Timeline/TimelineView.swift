import SwiftUI

enum Timeline_Hot_Tab {
    case timeline,hotQuestion
}

struct TimelineView: View {
    
    @State var currentTab : Timeline_Hot_Tab =  .timeline
    
    var body: some View {
        VStack{
            VStack{
                navBar
                tabChangeBar
            }
            .background(Rectangle()
                .fill(Color.white)
                .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
            )
            
            Spacer()
        }
        
        
        
    }
}

extension TimelineView {
    var navBar : some View {
        HStack{
            Circle()
                .frame(width: 32,height: 32)
            Spacer()
            Image("Logo Small")
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)
            Spacer()
            Image(systemName: "magnifyingglass")
                .fontWeight(.bold)
                .font(.system(size: 28))
                .foregroundColor(Color("Main Secondary"))
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
    }
    var tabChangeBar : some View {
        HStack(spacing: 20){
            Spacer()
            ZStack(alignment: .bottom){
                Button(action: {
                    currentTab = .timeline
                }){
                    if currentTab == .timeline {
                        VStack(alignment: .center, spacing: 0){
                            Text("타임라인")
                                .font(Font.system(size: 16, weight: .bold))
                                .accentColor(.black)
                                .padding(.bottom, 9)
                            Rectangle()
                                .fill(Color("Main Secondary"))
                                .frame(width: 50, height: 3)
                        }
                    } else {
                        Text("타임라인")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 12)
                    }
                }
                .accentColor(.black)
            }
            Spacer()
            ZStack(alignment: .bottom){
                Button(action: {
                    currentTab = .hotQuestion
                }){
                    if currentTab == .hotQuestion {
                        VStack(alignment: .center, spacing: 0){
                            Text("지금 핫한 질문")
                                .font(Font.system(size: 16, weight: .bold))
                                .accentColor(.black)
                                .padding(.bottom, 9)
                            Rectangle()
                                .fill(Color("Main Secondary"))
                                .frame(width: 50, height: 3)
                        }
                    } else {
                        Text("지금 핫한 질문")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 12)
                    }
                }
                .accentColor(.black)
            }
            Spacer()
        }
        .padding(.top,10)
    }
}


struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
