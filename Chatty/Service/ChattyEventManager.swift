import Foundation
import Combine

class ChattyEventManager {
    static let share = ChattyEventManager()
    let showAlter = PassthroughSubject<String,Never>()
    
}
