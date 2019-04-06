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
        static let base = "https://parse.udacity.com/parse/classes"
        
        case getStudentLocations(Int)
        
        var stringValue: String {
            switch self {
            case .getStudentLocations(let limit): return Endpoints.base + "/StudentLocation?limit=\(limit)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getStudentLocations(limit: Int = 50, completion: @escaping ([StudentInformation], Error?) -> Void) {
        let url = Endpoints.getStudentLocations(limit).url
        
        taskForGETRequest(url: url, responseType: StudentLocationResponse.self, headers: headers) { (response, error) in
            print("taskForGETRequest response: \(response) error: \(error)")
            if let response = response {
                completion(response.results.filter({ $0.isValid }), error)
            } else {
                completion([], error)
            }
        }

    }
}
