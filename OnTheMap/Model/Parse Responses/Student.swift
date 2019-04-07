//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct Student: Codable {
    let latitude: Float?
    let longitude: Float?
    let mediaURL: String?
    let firstName: String?
    let lastName: String?
    
    var isValid: Bool {
        guard let _ = latitude, let _ = longitude, let _ = mediaURL, let _ = firstName, let _ = lastName else {
            return false
        }
        return true
    }
}
