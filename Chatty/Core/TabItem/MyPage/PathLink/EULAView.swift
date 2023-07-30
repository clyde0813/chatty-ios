//
//  EULAView.swift
//  Chatty
//
//  Created by Clyde on 2023/05/08.
//

import SwiftUI

struct EULAView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader{ proxy in
            VStack{
                HStack{
                    HStack{
                        Button(action:{
                            presentationMode.wrappedValue.dismiss()
                        }){
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color.black)
                                .padding(.trailing, 20)
                        }
                        .padding(.leading, 30)
                        Spacer()
                    }
                    .frame(width: proxy.size.width / 3)
                    ZStack{
                        Image("Logo Small")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                    }
                    .frame(width: proxy.size.width / 3)
                    ZStack{
                        
                    }
                    .frame(width: proxy.size.width / 3)
                }
                .frame(width: proxy.size.width, height: 60)
                .background(Rectangle()
                    .fill(Color.white)
                    .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
                )
                ScrollView{
                    Text("이용자 계약(EULA)\n\n이 계약은 Chatty (이하 '회사')와 이용자(이하 '이용자') 간에 익명으로 질문을 하고 답변을 하는 플랫폼 'Chatty' 이용과 관련하여 내용을 기재합니다.\n\n1. 이용약관의 목적\n본 이용약관은 회사가 제공하는 'Chatty' 서비스(이하 '서비스')의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항 등을 규정함을 목적으로 합니다.\n이용자는 서비스 이용을 위해 회사의 이용약관에 동의하여야 합니다. 회사는 이용자가 본 이용약관에 동의한 경우, 서비스 이용에 필요한 필수 정보를 이용자로부터 수집합니다.\n\n2. 서비스의 이용\n이용자는 서비스를 이용하기 위해 본인의 ID 및 비밀번호를 설정하여야 합니다.\n이용자는 설정한 ID 및 비밀번호를 제3자에게 누설하거나 공유하지 않아야 합니다.\n이용자는 서비스를 이용함으로써 얻은 정보를 본인의 개인적인 용도로만 이용해야 하며, 이를 제3자에게 제공하거나 공유하지 않아야 합니다. 또한, 이용자는 서비스 이용 시 다음과 같은 행위를 해서는 안됩니다.\n• 타인의 명예를 손상시키거나 사생활을 침해하는 행위\n• 타인의 지적재산권을 침해하는 행위\n• 범죄와 결부된다고 객관적으로 인정되는 행위\n• 불쾌감을 유발할 수 있는 내용, 욕설, 비속어, 음란물 등을 게시하는 행위\n• 기타 관계 법령에 위배되는 행위\n\n3. 개인정보 처리\n회사는 서비스 이용과 관련하여 이용자로부터 개인정보를 수집할 수 있습니다.\n이 경우 회사는 개인정보 보호 관련 법령에 따라 이용자의 개인정보를 보호합니다.\n\n4. 면책조항\n회사는 이용자의 귀책 사유로 인해 발생한 손해에 대해 책임지지 않습니다. 또한, 회사는 서비스 제공을 위해 필요한 경우 예고 없이 서비스 내용을 변경할 수 있습니다.\n\n5. 분쟁해결\n이 이용약관에 따른 분쟁은 이용자와 회사 간의 합의를 바탕으로 원만하게 해결되어야 합니다\n이용자는 서비스 이용과 관련하여 발생한 분쟁을 회사와 상호 협의하여 해결할 수 있습니다. 만약 분쟁이 해결되지 않을 경우, 관할 법원에서 해결해야 합니다.\n\n6. 약관의 효력과 변경\n본 이용약관은 이용자와 회사 간의 합의에 따라 효력을 발생합니다. 회사는 필요한 경우 이용약관을 변경할 수 있으며, 변경된 이용약관은 회사 웹사이트에 게시함으로써 공지됩니다. 이용자는 변경된 이용약관에 동의하지 않을 경우 서비스 이용을 중단할 수 있습니다.\n\n7. 기타\n본 이용약관은 대한민국의 법령에 따라 규정됩니다. 이용자와 회사 간의 서비스 이용과 관련하여 발생한 모든 분쟁은 대한민국 법률에 따라 해결됩니다.\n\n8. 개인정보 수집 동의\n회사는 서비스 이용과 관련하여 이용자의 개인정보를 수집할 수 있습니다. 이용자가 개인정보 수집에 동의하지 않을 경우, 서비스 이용이 제한될 수 있습니다. 회사는 수집한 개인정보를 이용자의 동의 없이 제3자에게 제공하거나 공유하지 않습니다.\n\n8. 불쾌한 내용 및 욕설에 대한 관용의 부재\n회사는 불쾌한 내용이나 욕설을 하는 사용자에 대한 관용이 없음을 분명히 하며, 해당 내용이 발견될 경우 해당 사용자의 계정을 일시 정지하거나 영구 정지할 수 있습니다. 이용자들의 쾌적한 서비스 이용 환경을 위해 불쾌한 내용이나 욕설을 삼가해주시기 바랍니다.\n\n위와 같이 Chatty 서비스 이용약관을 동의하시면 서비스 이용이 가능합니다.")
                }
                .font(.system(size: 13, weight: .none))
                .padding([.leading, .trailing], 20)
                .padding(.top, 20)
            }
        }
        .navigationBarHidden(true)
    }
}

struct EULAView_Previews: PreviewProvider {
    static var previews: some View {
        EULAView()
    }
}
