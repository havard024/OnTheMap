//
//  UdacityResponse.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct UdacityResponse: Codable {
    let status: Int
    let parameter: String?
    let error: String
}

extension UdacityResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
