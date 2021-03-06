//
//  SecondViewController.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class PinListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        handleRefresh()
        tableView.reloadData()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        handleLogout()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        handleAdd()
    }
}

extension PinListViewController: UITableViewDelegate {
    
}

extension PinListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let student = StudentModel.students[indexPath.row]
        let name = "\(student.firstName!) \(student.lastName!)"
        
        cell.textLabel?.text = name
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentModel.students[indexPath.row]
        let app = UIApplication.shared
        if let toOpen = student.mediaURL {
            app.openURL(URL(string: toOpen)!)
        }
    }
    

}
