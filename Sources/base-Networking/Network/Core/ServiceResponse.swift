//  Created by Carlos Daniel Hernandez Chauteco

import Foundation

enum ServiceResponse <ResponseModel> {
    case success (data: [ResponseModel])
    case notSuccess (error: ServiceErrorResponse)
    case notConnectedToInternet
}
