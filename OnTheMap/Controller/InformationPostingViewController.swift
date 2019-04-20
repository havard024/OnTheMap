//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by mac on 4/20/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

struct InformationPost {
    let location: String
    let link: String
    let coordinate: CLLocationCoordinate2D
    
    var annotation: MKPointAnnotation {
        get {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location
            return annotation
        }
    }
}

class InformationPostingViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    private var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTextField.text = "Oslo"
        linkTextField.text = "https://google.com"
        // Do any additional setup after loading the view.
    }
    

    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true
            , completion: nil)
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        guard let location = locationTextField.text, !location.isEmpty, let link = linkTextField.text, !link.isEmpty
            else {
                showMessage(message: "Please fill in all fields.")
            return
        }
        
        getCoordinate(addressString: location, completionHandler: handleCoordinateResponse)
    }
    
    private func handleCoordinateResponse(geolocation: CLLocationCoordinate2D) {
        if CLLocationCoordinate2DIsValid(geolocation) {
            // Store geolocation so we can use it in prepare function
            coordinate = geolocation
            performSegue(withIdentifier: "showInformationPostingMap", sender: self)
        } else {
            // Not sure why but changing the show(...) to present(...) for the alert solved the problem where the alert is displayed awkwardly in the top left corner
            // It seems to be related to that we're presenting an AlertViewController on top of a modal
            // Ref: https://stackoverflow.com/a/54408645
            let alertVC = UIAlertController(title: "Info", message: "Could not convert location to geolocation: \(locationTextField.text ?? "")", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alertVC.modalPresentationStyle = .overFullScreen

            present(alertVC, animated: true, completion: nil)
            
            // Using the below method shows the alert message in top left corner
            // showMessage(message: "Could not convert location to geolocation: \(locationTextField.text ?? "")")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let coordinate = coordinate else {
            preconditionFailure("Coordinate is empty, can't segue without it.")
        }
        
        guard let identifier = segue.identifier, identifier == "showInformationPostingMap" else {
            return
        }
        
        
        let vc = segue.destination as! InformationPostingMapViewController
        
        // TODO: Should probably refactor so we don't need to force unwrap text fields
        let informationPost = InformationPost(location: locationTextField.text!, link: linkTextField.text!, coordinate: coordinate)
        vc.informationPost = informationPost
    }
    
    private func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D) -> Void ) {
        Spinner.start()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    DispatchQueue.main.async {
                        Spinner.stop()
                        completionHandler(location.coordinate)
                    }
                    
                    return
                }
            }
            
            DispatchQueue.main.async {
                Spinner.stop()
                completionHandler(kCLLocationCoordinate2DInvalid)
            }
        }
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
