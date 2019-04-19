//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by mac on 4/20/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTextField.text = "Oslo"
        linkTextField.text = "google.com"
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
    
    private func handleCoordinateResponse(geolocation: CLLocationCoordinate2D, error: NSError?) {
        if error != nil {
            showMessage(message: "Could not convert location to geolocation: \(locationTextField.text ?? "")")
        } else {
            // TODO: Navigate to mapview and show geolocation
        }
    }
    
    private func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        Spinner.start()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    DispatchQueue.main.async {
                        Spinner.stop()
                        completionHandler(location.coordinate, nil)
                    }
                    
                    return
                }
            }
            
            DispatchQueue.main.async {
                Spinner.stop()
                completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
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
