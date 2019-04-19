//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by mac on 4/20/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func handleRefresh() {
        ParseClient.getStudentLocations(completion: handleStudentsResponse)
    }
    
    func handleStudentsResponse(students: [Student], error: Error?) {
        if error == nil {
            StudentModel.students = students
        } else {
            self.showGetStudentInformationFailed(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleLogout() {
        UdacityClient.logout(completion: handleLogoutResponse)
    }
    
    func handleLogoutResponse(error: Error?) {
        if error == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.showLogoutFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleAdd() {
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
