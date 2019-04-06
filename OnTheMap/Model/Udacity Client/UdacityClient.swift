//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class UdacityClient: BaseClient<UdacityResponse> {
    
    struct Auth {
        static var accountId = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com"
        
        case createSessionId
        case logout
        
        var stringValue: String {
            switch self {
            case .createSessionId: return Endpoints.base + "/v1/session"
            case .logout: return Endpoints.base + "/v1/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = Endpoints.createSessionId.url
        let body = PostSession(udacity: Credentials(username: username, password: password))
        taskForPOSTRequest(url: url, responseType: SessionResponse.self, body: body, dataTransformer: { $0.subdata(in: 5..<$0.count)} ) { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.accountId = response.account.key
                completion(true, error)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping (Error?) -> Void) {
        Spinner.start()
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "Delete"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                Spinner.stop()
                completion(error)
            }
        }
        task.resume()
    }
}
