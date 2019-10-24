//
//  EditPlaceDetailsVC.swift
//  YuluTest
//
//  Created by Saraswati C on 20/10/19.
//  Copyright © 2019 company. All rights reserved.
//

import UIKit

class EditPlaceDetailsVC: UIViewController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var lblImage: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    var place: Place?
    var lat: Double?
    var long : Double?
    
    var forNewPlace: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        if forNewPlace {
            loadSelectedLocation()
        } else {
           loadExistingPlaceData()
        }
        if txtTitle.text! == nil || txtTitle.text! == "" {
            btnSave.isEnabled = false
            btnSave.alpha = 0.5
        } else {
            btnSave.isEnabled = true
            btnSave.alpha = 1.0
        }
        txtTitle.addTarget(self, action: #selector(EditPlaceDetailsVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
       
    }
    
    func loadSelectedLocation() {
        txtTitle.text =  ""
        txtDescription.text =  ""
        lblLocation.text  = "\(lat ?? 0.0), \(long ?? 0.0)"
    }
    
    func loadExistingPlaceData() {
        txtTitle.text = place?.title ?? ""
        txtDescription.text = place?.description ?? ""
        lat = place?.latitude
        long = place?.longitude
        lblLocation.text  = "\(lat ?? 0.0), \(long ?? 0.0)"
        
    }
    
    func loadData() {
        
        
        viewLocation.layer.borderWidth = 1.0
        viewLocation.layer.borderColor = UIColor.black.cgColor
        viewLocation.layer.cornerRadius = 4.0
        
        txtDescription.layer.borderWidth = 1.0
        txtDescription.layer.borderColor = UIColor.black.cgColor
        txtDescription.layer.cornerRadius = 4.0
        
        viewImage.layer.borderWidth = 1.0
        viewImage.layer.borderColor = UIColor.black.cgColor
        viewImage.layer.cornerRadius = 4.0
        
        btnSave.layer.cornerRadius = 4.0
        

        
        let tapLoc = UITapGestureRecognizer(target: self, action: #selector(self.handleLocationTap(_:)))
        viewLocation.addGestureRecognizer(tapLoc)
        
        let tapImg = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
        viewImage.addGestureRecognizer(tapImg)
    
    }
    
    @IBAction func clickSave(_ sender: Any) {
        
            if forNewPlace { 
                APIManager.sharedInstance.addNewPlaceDetails(title: txtTitle.text!, description: txtDescription.text!, latitude: lat ?? 0.0, longitude: long ?? 0.0, imgUrl: "", onSuccess: { place in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }, onFailure: { error in
                    print("error")
                })
                
            } else {
                APIManager.sharedInstance.updatePlaceDetailsUsingId(placeId: place?.id ?? "", title: txtTitle.text!, description: txtDescription.text!, latitude: lat ?? 0.0, longitude: long ?? 0.0, imgUrl: "", onSuccess: { place in
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }, onFailure: { error in
                    print("error")
                })
                
            }
        
        
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == txtTitle {
            if textField.text! == nil || textField.text! == "" {
                btnSave.isEnabled = false
                btnSave.alpha = 0.5
            } else {
               btnSave.isEnabled = true
                btnSave.alpha = 1.0
            }
            
        }
    }
    
    @objc func handleLocationTap(_ sender: UITapGestureRecognizer? = nil) {
        performSegue(withIdentifier: "toSelectLocationFromEdit", sender: self)
    }
    
    
    @objc func handleImageTap(_ sender: UITapGestureRecognizer? = nil) {
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectLocationFromEdit" {
            let destVC:SelectLocationVC = segue.destination as! SelectLocationVC
            destVC.latitude = lat ?? 0.0
            destVC.longitude = long ?? 0.0
            destVC.delegate = self
        }
    }
    

}

extension EditPlaceDetailsVC: LocationSelectionDelegate {
    func updateLocation(_ lat: Double, _ long: Double) {
        self.lat = lat
        self.long = long
        lblLocation.text  = "\(lat ), \(long)"
    }
    
    
}
