//
//  ParseResponse.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct ParseResponse: Codable {
    let error: String
}

extension ParseResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
