//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var accountId = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com"
        
        case createSessionId
        
        var stringValue: String {
            switch self {
            case .createSessionId: return Endpoints.base + "/v1/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let newData = data.subdata(in: 5..<data.count)
            let decoder = JSONDecoder()
            // print(String(data: newData, encoding: .utf8)!)

            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, error)
                }
                
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskforGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) ->  URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let newData = data.subdata(in: 5..<data.count)
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, error)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = Endpoints.createSessionId.url
        let body = PostSession(udacity: Credentials(username: username, password: password))
        taskForPOSTRequest(url: url, responseType: SessionResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.accountId = response.account.key
                completion(true, error)
            } else {
                completion(false, error)
            }
        }
    }
}
