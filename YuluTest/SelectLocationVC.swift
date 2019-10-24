//
//  SelectLocationVC.swift
//  YuluTest
//
//  Created by Saraswati C on 21/10/19.
//  Copyright © 2019 company. All rights reserved.
//

import UIKit
import MapKit

protocol LocationSelectionDelegate:class {
    func updateLocation(_ lat: Double, _ long: Double)
}

class SelectLocationVC: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var btnUpdate: UIButton!
    var latitude:Double?
    var longitude:Double?
    var delegate:LocationSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
         setupMap()
    }
    
    @IBAction func clickUpdate(_ sender: Any) {
        let updatedLoc = map.centerCoordinate
        delegate?.updateLocation(updatedLoc.latitude, updatedLoc.longitude)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupMap() {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0),
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        map.setCenter(CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0), animated: true)
        
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
