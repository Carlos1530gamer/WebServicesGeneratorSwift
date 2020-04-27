//  Created by Carlos Daniel Hernandez Chauteco

import Foundation

struct DictionaryEncode: EncodingProtocol {
    
    static let shared = DictionaryEncode()
    
    func encode(dic: [String : Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
    }
}
