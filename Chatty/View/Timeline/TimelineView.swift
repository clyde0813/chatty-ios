import SwiftUI

struct TimelineView: View {
    var body: some View {
        VStack{
            navBar
            HStack{
                
            }
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
        .background(Rectangle()
            .fill(Color.white)
            .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
        )
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
