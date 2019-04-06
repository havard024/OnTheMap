//
//  PostSession.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct Credentials: Codable {
    let username: String
    let password: String
}

struct PostSession: Codable {
    let udacity: Credentials
}
