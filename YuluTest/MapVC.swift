//
//  MapVC.swift
//  YuluTest
//
//  Created by Saraswati C on 20/10/19.
//  Copyright © 2019 company. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D?
    var placesList: [Place] = []
    var placesAnnotations: [MKAnnotation] = []
    
    var newLat: Double = 0.0
    var newLong: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        
        
        
    }
    
    func setupMap() {
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            map.setRegion(coordinateRegion, animated: true)
        }
        
        for place in placesList {
            let newAnnotation : MKPointAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude ?? 0.0, longitude: place.longitude ?? 0.0)
            newAnnotation.title = place.title
            placesAnnotations.append(newAnnotation)
        }
        
        map.addAnnotations(placesAnnotations)
        map.setCenter(currentLocation!, animated: true)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleMapTap(_:)))
        map.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleMapTap(_ sender: UITapGestureRecognizer? = nil) {
        
        guard let location = sender?.location(in: map) else { return }
        let coordinate = map.convert(location,toCoordinateFrom: map)
        
        
        newLat = coordinate.latitude
        newLong = coordinate.longitude
        performSegue(withIdentifier: "ToEditFromMap", sender: self)
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToEditFromMap" {
            let destVC:EditPlaceDetailsVC = segue.destination as! EditPlaceDetailsVC
            destVC.lat = self.newLat
            destVC.long = self.newLong
            destVC.forNewPlace = true
        }
    }
 

}

extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.currentLocation = locValue
        self.locationManager.stopUpdatingLocation();
        setupMap()
    }
    
}
