//  Created by Carlos Daniel Hernandez Chauteco

import Foundation

enum ResponseStatusCode: Int {
    case successCode = 200
    case successCreated = 201
    case acepted = 202
    case badRequest = 400
    case unauthorizedCode = 401
    case internalServerError = 500
    case unknowedError = 0
    
    static func getStatusForCode(_ rawValue: Int) -> ResponseStatusCode {
        switch rawValue {
        case 200: return .successCode
        case 201: return .successCreated
        case 202: return .acepted
        case 400: return .badRequest
        case 401: return .unauthorizedCode
        case 500: return .internalServerError
        default: return .badRequest
        }
    }
}
