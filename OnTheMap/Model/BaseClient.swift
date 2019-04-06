//
//  BaseClient.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class BaseClient<ClientResponse> where ClientResponse: Decodable, ClientResponse: LocalizedError {
    
    typealias dataTransformerHandler = (Data) -> Data
    private class func defaultDataTransformer(data: Data) -> Data {
        return data
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, headers: [String:String]? = [:], completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return taskForMethodRequest(request: request, responseType: responseType, headers: headers!, completion: completion)
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, headers: [String:String]? = [:], dataTransformer: dataTransformerHandler?, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        
        return taskForMethodRequest(request: request, responseType: responseType, headers: headers!, dataTransformer: dataTransformer, completion: completion)
    }
    
    private class func taskForMethodRequest<ResponseType: Decodable>(request: URLRequest, responseType: ResponseType.Type, headers: [String:String] = [:], dataTransformer: dataTransformerHandler? = defaultDataTransformer, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        Spinner.start()
        var request = request
        headers.keys.forEach { request.addValue(headers[$0]!, forHTTPHeaderField: $0 )}
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    Spinner.stop()
                    completion(nil, error)
                }
                return
            }
            
            let newData = dataTransformer!(data)
            let decoder = JSONDecoder()
            print(String(data: newData, encoding: .utf8)!)
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    Spinner.stop()
                    completion(responseObject, error)
                }
                
            } catch {
                print("ERROR: \(error)")
                do {
                    let errorResponse = try decoder.decode(ClientResponse.self, from: newData)
                    DispatchQueue.main.async {
                        Spinner.stop()
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        Spinner.stop()
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
}
