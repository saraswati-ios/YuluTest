//
//  PlaceDetailsVC.swift
//  YuluTest
//
//  Created by Saraswati C on 20/10/19.
//  Copyright © 2019 company. All rights reserved.
//

import UIKit

class PlaceDetailsVC: UIViewController {
    @IBOutlet weak var imgPlace: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    
    var placeID:String?
    
    var PlaceDetails: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLocation.layer.borderWidth = 1.0
        viewLocation.layer.borderColor = UIColor.black.cgColor
        viewLocation.layer.cornerRadius = 4.0
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPlaceDetails()
    }
    @IBAction func clickEdit(_ sender: Any) {
        performSegue(withIdentifier: "ToEditFromPlaceDetails", sender: self)
    }
    
    func getPlaceDetails() {
        APIManager.sharedInstance.getPlaceDetailsUsingId(placeId: placeID ?? "" , onSuccess: { place in
            DispatchQueue.main.async {
                self.PlaceDetails = place
                self.lblTitle.text = place.title ?? ""
                self.lblDescription.text = place.description ?? ""
                self.lblLocation.text = "\(place.latitude ?? 0.0), \(place.longitude ?? 0.0)"
                if let imgurl = place.imageUrl {
                  self.downloadImage(from: URL(string: "http://35.154.73.71/api/v1\(imgurl)")!)
                }
                
            }
        }, onFailure: { error in
            print("error")
        })
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imgPlace.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToEditFromPlaceDetails" {
            let destVC:EditPlaceDetailsVC = segue.destination as! EditPlaceDetailsVC
            destVC.place = self.PlaceDetails
        }
    }
 

}
