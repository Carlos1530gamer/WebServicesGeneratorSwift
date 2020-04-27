//  Created by Carlos Daniel Hernandez Chauteco

import Foundation


/// Protocol desribe a base of all new web services, only implement and re-write the need functions
protocol CoreServiceProtocol {
    associatedtype ServiceModel
    var webServiceEndpoint: Endpoint { get }
    
    func parse(_ data: Data?, statusCode: ResponseStatusCode) -> [ServiceModel]?
    func parseSuccessCreated(_ data: Data?, statusCode: ResponseStatusCode) -> [ServiceModel]?
    func parseError (_ data: Data?, statusCode: ResponseStatusCode) -> ServiceErrorResponse?
}

extension CoreServiceProtocol {
    
    func callToWebService(to endpoint: String, headers: [String: String], timeOut: TimeInterval, httpMethod: HTTPMethod, body: [String: Any]? = nil, bodyEncode: EncodingProtocol = DictionaryEncode.shared, completion: @escaping (ServiceResponse<ServiceModel>) -> Void) {
        guard let url = URL(string: endpoint) else { completion(.notSuccess(error: .genericError)); return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.timeoutInterval = timeOut
        
        if let body = body {
            urlRequest.httpBody = bodyEncode.encode(dic: body)
        }
        
        URLSession(configuration: .ephemeral).dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, let httpCode = ResponseStatusCode(rawValue: httpResponse.statusCode) else {
                self.process(error: error, completion: completion)
                return
            }
            
            switch httpCode {
            case .successCode:
                self.handleSuccessRequest(data: data, statusCode: httpCode, completion: completion)
            case .successCreated:
                self.handleSuccessCreated(data: data, statusCode: httpCode, completion: completion)
            case .acepted:
                self.handleAceptedRequest(data: data, statusCode: httpCode, completion: completion)
            case .badRequest:
                self.handleBadRequest(data: data, statusCode: httpCode, completion: completion)
            case .unauthorizedCode:
                self.handlerUnknowedError(completion: completion)
            case .internalServerError:
                self.handlerUnknowedError(completion: completion)
            case .unknowedError:
                self.handlerUnknowedError(completion: completion)
            }
        }.resume()
    }
    
    //MARK: - Define parser funiontions to get model
    func parse(_ data: Data?, statusCode: ResponseStatusCode) -> [ServiceModel]? {
        return nil
    }
    
    func parseSuccessCreated(_ data: Data?, statusCode: ResponseStatusCode) -> [ServiceModel]? {
        return nil
    }
    
    func parseError (_ data: Data?, statusCode: ResponseStatusCode) -> ServiceErrorResponse? {
        return nil
    }
    
    //MARK: - Funtions to proccess all parser and errors
    private func handleSuccessRequest(data: Data?, statusCode: ResponseStatusCode, completion: @escaping (ServiceResponse<ServiceModel>) -> Void) {
        if let parseData = parse(data, statusCode: statusCode) {
            completion(.success(data: parseData))
        } else {
            completion(.success(data: []))
        }
    }
    
    private func handleAceptedRequest(data: Data?, statusCode: ResponseStatusCode, completion: @escaping (ServiceResponse<ServiceModel>) -> Void) {
        if let parseData = parse(data, statusCode: statusCode) {
            completion(.success(data: parseData))
        } else {
            completion(.success(data: []))
        }
    }
    
    private func handleSuccessCreated(data: Data?, statusCode: ResponseStatusCode, completion: @escaping (ServiceResponse<ServiceModel>) -> Void) {
        if let parseData = parseSuccessCreated(data, statusCode: statusCode) {
            completion(.success(data: parseData))
        } else {
            completion(.success(data: []))
        }
    }
    
    private func handleBadRequest(data: Data?, statusCode: ResponseStatusCode, completion: @escaping (ServiceResponse<ServiceModel>) -> Void) {
        if let error = self.parseError(data, statusCode: statusCode) {
            completion(.notSuccess(error: error))
        } else {
            completion(.notSuccess(error: .genericError))
        }
    }
    
    private func process(error: Error?, completion: @escaping (ServiceResponse<ServiceModel>) -> Void) {
        if let nsError = error as NSError?, nsError.code == NSURLErrorNotConnectedToInternet {
            self.handleNoInternetConnection(completion: completion)
        } else {
            self.handlerUnknowedError(completion: completion)
        }
    }
    
    
    private func handleNoInternetConnection(completion: @escaping (ServiceResponse<ServiceModel>) -> Void) {
        completion(.notConnectedToInternet)
    }
    
    private func handlerUnknowedError(completion: @escaping (ServiceResponse<ServiceModel>) -> Void) {
        completion(.notSuccess(error: .genericError))
    }
}
