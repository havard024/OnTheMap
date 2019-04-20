//
//  ParseClient.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class ParseClient: BaseClient<ParseResponse> {
    
     static let headers = ["X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"]
    
    struct Auth {
        static var applicationId = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://parse.udacity.com/parse/classes/StudentLocation"
        
        case getStudentLocations(Int)
        case createStudentLocation
        
        var stringValue: String {
            switch self {
            case .getStudentLocations(let limit): return Endpoints.base + "?limit=\(limit)&order=-updatedAt"
            case .createStudentLocation: return Endpoints.base
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getStudentLocations(limit: Int = 100, completion: @escaping ([Student], Error?) -> Void) {
        let url = Endpoints.getStudentLocations(limit).url
        
        taskForGETRequest(url: url, responseType: StudentLocationResponse.self, headers: headers) { (response, error) in
            // Could not find a way to filter out empty values with the parse API, so we filter out after getting the response which means the returned values might be < 100
            if let response = response {
                completion(response.results.filter({ $0.isValid }), error)
            } else {
                completion([], error)
            }
        }
    }
    
    class func postStudentLocation(student: PostStudent, completion: @escaping (PostStudentResponse?, Error?) -> Void) {
        let url = Endpoints.createStudentLocation.url
        taskForPOSTRequest(url: url, responseType: PostStudentResponse.self, body: student, headers: headers) { (student, error) in
            if let student = student {
                completion(student, error)
            } else {
                completion(nil, error)
            }
        }
    }
}
