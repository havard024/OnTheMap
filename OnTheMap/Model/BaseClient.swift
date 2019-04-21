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
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, headers: [String:String]? = [:], dataTransformer: dataTransformerHandler? = defaultDataTransformer, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        
        return taskForMethodRequest(request: request, responseType: responseType, headers: headers!, dataTransformer: dataTransformer, completion: completion)
    }
    
    enum APIError: Swift.Error, LocalizedError {
        case requestError(Error)
        case responseError(HTTPURLResponse)
        case dataNotSet
        case decodeError(Error)
        case unknownResponse
        
        var localizedDescription: String {
            switch self {
            case .requestError(let error):
                return "Error \(error.localizedDescription)"
            case .responseError(let response):
                return "Error \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))"
            case .dataNotSet:
                return "Response was successfull but return data was empty, what happened?"
            case .decodeError(let error):
                return "Error failed to decode returned data: \(error)"
            case .unknownResponse:
                return "Error response was not a HTTPURLResponse, how do we handle this?"
            }
        }
    }
    
    private class func taskForMethodRequest<ResponseType: Decodable>(request: URLRequest, responseType: ResponseType.Type, headers: [String:String] = [:], dataTransformer: dataTransformerHandler? = defaultDataTransformer, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        DispatchQueue.main.async {
            Spinner.start()
        }
        var request = request
        headers.keys.forEach { request.addValue(headers[$0]!, forHTTPHeaderField: $0 )}
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // TODO: needs major refactor / clean up
            if let error = error {
                DispatchQueue.main.async {
                    Spinner.stop()
                    completion(nil, APIError.requestError(error))
                }
            } else if let response = response {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
                        if let data = data {
                            let newData = dataTransformer!(data)
                            let decoder = JSONDecoder()
                            print(String(data: newData, encoding: .utf8)!)
                            
                            do {
                                let errorResponse = try decoder.decode(ClientResponse.self, from: newData)
                                DispatchQueue.main.async {
                                    Spinner.stop()
                                    completion(nil, errorResponse)
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    Spinner.stop()
                                    completion(nil, APIError.decodeError(error))
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                Spinner.stop()
                                completion(nil, APIError.unknownResponse)
                            }
                        }
                    } else if let data = data {
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
                            DispatchQueue.main.async {
                                Spinner.stop()
                                completion(nil, APIError.requestError(error))
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            Spinner.stop()
                            completion(nil, APIError.dataNotSet)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        Spinner.stop()
                        completion(nil, APIError.unknownResponse)
                    }
                }
            }
        }
        task.resume()
        return task
    }
}
