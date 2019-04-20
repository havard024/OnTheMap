//
//  FirstViewController.swift
//  OnTheMap
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class StudentLocation: NSObject, MKAnnotation {
    let id: String
    let coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(id: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.coordinate = coordinate
    }
}

class MapViewController: BaseViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func logoutTapped(_ sender: Any) {
        handleLogout()
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        handleRefresh()
        setAnnotations()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        handleAdd()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        setAnnotations()
    }
    
    private func setAnnotations() {
        var annotations = [MKPointAnnotation]()
    
        StudentModel.students.forEach { student in
        // Students with empty values are filtered before stored inside the StudentModel, so we are sure that the students here will have values in the fields we access
        let latitude = student.latitude!
        let longitude = student.longitude!
        let firstName = student.firstName!
        let lastName = student.lastName!
        let mediaURL = student.mediaURL!
        let name = "\(firstName) \(lastName)"
    
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        annotation.subtitle = mediaURL
    
        print("name: \(name) mediaURL: \(mediaURL)")
        annotations.append(annotation)
        }
    
        mapView.addAnnotations(annotations)
    }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}

