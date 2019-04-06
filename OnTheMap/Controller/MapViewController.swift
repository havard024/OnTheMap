//
//  FirstViewController.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    @IBAction func logoutTapped(_ sender: Any) {
        UdacityClient.logout(completion: self.handleLogoutResponse)
    }
    
    func handleLogoutResponse(error: Error?) {
        if error == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            showLogoutFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func showLogoutFailure(message: String) {
        let alertVC = UIAlertController(title: "Logout Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

