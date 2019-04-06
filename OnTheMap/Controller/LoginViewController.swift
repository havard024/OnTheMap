//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: LoginButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func loginTapped(_ sender: Any) {
        UdacityClient.createSessionId(username: emailTextField?.text ?? "", password: passwordTextField?.text ?? "", completion: self.handleSessionResponse)
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        if success {
            ParseClient.getStudentLocations(completion: self.handleStudentInformationResponse)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleStudentInformationResponse(students: [StudentInformation], error: Error?) {
        print("Students: \(students) count: \(students.count)")
        if error == nil {
            performSegue(withIdentifier: "showHome", sender: self)
        } else {
            showGetStudentInformationFailed(message: error?.localizedDescription ?? "")
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
    
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func showGetStudentInformationFailed(message: String) {
        let alertVC = UIAlertController(title: "Students failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
