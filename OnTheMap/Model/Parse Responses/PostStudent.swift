//
//  PostStudent.swift
//  OnTheMap
//
//  Created by mac on 4/20/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct PostStudent: Codable {
    // TODO: Set key to be users account id
    let uniqueKey = UUID().uuidString
    let latitude: Double
    let longitude: Double
    let mediaURL: String
    // TODO: Could set first name and last name based on data from public user data API
    let firstName = "First Name"
    let lastName = "Last Name"
}
