//
//  InformationPostingMapViewController.swift
//  OnTheMap
//
//  Created by mac on 4/20/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var informationPost: InformationPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        guard let informationPost = informationPost else {
            preconditionFailure("informationPost was empty when view was presented, did you forget to set the informationPost before navigating?")
            return
        }
        
        let region = MKCoordinateRegion(center: informationPost.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
        
        let annotation = informationPost.annotation
        mapView.addAnnotation(annotation)
        
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        let uuid = UUID().uuidString
        
        // TODO: Refactor so that we don't need to set default values inside constructor
        let student = PostStudent(latitude: informationPost?.coordinate.latitude ?? 0.0, longitude: informationPost?.coordinate.longitude ?? 0.0, mediaURL: informationPost?.link ?? "")
        print(student)
        
        // TODO: If logged in user already has a pin, update that pin instead
        ParseClient.postStudentLocation(student: student, completion: handlePostStudentResponse)
    }
    
    private func handlePostStudentResponse(student: PostStudentResponse?, error: Error?) {
        guard let student = student else {
            showMessage(message: "Could not create new student: \(error?.localizedDescription)")
            return
        }
        
        performSegue(withIdentifier: "unwind", sender: self)
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

extension InformationPostingMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
