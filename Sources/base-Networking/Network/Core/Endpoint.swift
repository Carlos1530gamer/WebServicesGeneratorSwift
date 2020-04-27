//  Created by Carlos Daniel Hernandez Chauteco

import Foundation


/// Enum with all web services
enum Endpoint: String {
    case newEndpoint
}

extension Endpoint {
    struct Constants {
        struct EnpointDicConstants {
            static let path = "path"
            static let timeOut = "timeOut"
        }
    }
    
    
    static private var baseHeaders: Dictionary<String,String> {
        [
            "Content-Type": "application/json"
        ]
    }
}

extension Endpoint {
    
    func getURL() -> String {
        typealias PathsConstants = Secrets.BaseUrl
        typealias LocalK = Constants.EnpointDicConstants
        var apiBasePath = ""
        guard let relativePath = getEndpointDic()[LocalK.path] as? String else { return apiBasePath }
        
        switch self {
        case .newEndpoint:
            apiBasePath = PathsConstants.baseUrl
        }
        
        return apiBasePath + relativePath
    }
    
    func getHeaders() -> [String : String] {
        var returnHeaders = Endpoint.baseHeaders
        switch self {
        case .newEndpoint:
            break
        }
        return returnHeaders
    }
    
    func getTimeOut() -> TimeInterval {
        typealias LocalK = Constants.EnpointDicConstants
        guard let timeOut = getEndpointDic()[LocalK.timeOut] as? Int else { return 60 }
        return TimeInterval(timeOut)
    }
    
    private func getEndpointDic() -> [String: AnyObject] {
        return (Secrets.endpoints[self.rawValue] as? [String: AnyObject]) ?? [:]
    }
}
