//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct Student: Codable {
    let objectId: String
    let latitude: Double?
    let longitude: Double?
    let mediaURL: String?
    let firstName: String?
    let lastName: String?
    
    var isValid: Bool {
        guard let _ = latitude, let _ = longitude, let mediaURL = mediaURL, !mediaURL.isEmpty, let firstName = firstName, !firstName.isEmpty, let lastName = lastName, !lastName.isEmpty else {
            return false
        }
        return true
    }
}
