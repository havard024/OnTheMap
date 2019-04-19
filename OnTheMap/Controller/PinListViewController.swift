//
//  SecondViewController.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class PinListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PinListViewCell.self, forCellReuseIdentifier: "Cell")

    }
}

extension PinListViewController: UITableViewDelegate {
    
}

extension PinListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PinListViewCell()
        let student = StudentModel.students[indexPath.row]
        let name = "\(student.firstName!) \(student.lastName!)"
        
        cell.textLabel?.text = name
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentModel.students[indexPath.row]
        print("Student selected: \(student)")
    }
    
    
}
