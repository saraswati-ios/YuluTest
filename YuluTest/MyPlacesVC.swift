//
//  MyPlacesVC.swift
//  YuluTest
//
//  Created by Saraswati C on 20/10/19.
//  Copyright © 2019 company. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData

class MyPlacesVC: UIViewController {
    
    var placeslist:[Place] = []
    var selectedPlace: Place?
    @IBOutlet weak var placesTable: UITableView!
    @IBOutlet weak var btnMap: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesTable.dataSource = self
        placesTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork(){
            fetchPlaces()
        }else{
            fetchDataFromLocalStorage()
        }
        
    }
    
    @IBAction func clickBtnMap(_ sender: Any) {
        performSegue(withIdentifier: "toMapViewFromMyPlaces", sender: self)
    }
    
    func fetchPlaces() {
        APIManager.sharedInstance.getPlaces(onSuccess: { places in
            DispatchQueue.main.async {
                self.placeslist = places
                print(self.placeslist)
                if places.count > 0 {
                    self.updateLocalStorage()
                }
                self.placesTable.reloadData()
            }
        }, onFailure: { error in
            print("error")
        })
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapViewFromMyPlaces" {
            let destVC:MapVC = segue.destination as! MapVC
            destVC.placesList = self.placeslist
        } else if segue.identifier == "ToPlaceDetailsFromMyPlaces" {
            let destVC:PlaceDetailsVC = segue.destination as! PlaceDetailsVC
            destVC.placeID = self.selectedPlace?.id
            
        }
    }
    
    func deleteAllData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlaceData")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in PlaceData error :", error)
        }
    }
    
    func updateLocalStorage() {
        deleteAllData() 
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let placeEntity = NSEntityDescription.entity(forEntityName: "PlaceData", in: managedContext)!
        
        for newplace in self.placeslist {
            let place = NSManagedObject(entity: placeEntity, insertInto: managedContext)
            place.setValue(newplace.id ?? "", forKeyPath: "id")
            place.setValue(newplace.title ?? "", forKey: "title")
            place.setValue(newplace.description ?? "", forKeyPath: "desc")
            place.setValue(newplace.latitude ?? 0.0, forKey: "latitude")
            place.setValue(newplace.longitude ?? 0.0, forKeyPath: "longitude")
            place.setValue(newplace.imageUrl ?? "", forKey: "imageUrl")
        }
        
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func fetchDataFromLocalStorage() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "PlaceData")
        
        //3
        var placesFetched:[Place] = []
        do {
            let placeFromLocal = try managedContext.fetch(fetchRequest)
            for newPlace in placeFromLocal as! [NSManagedObject] {
                let addingPlace: Place = Place(id: newPlace.value(forKey: "id") as! String, title: newPlace.value(forKey: "title") as! String, description: newPlace.value(forKey: "desc") as? String ?? "", latitude: newPlace.value(forKey: "latitude") as! Double, longitude: newPlace.value(forKey: "longitude") as! Double, imageUrl: newPlace.value(forKey: "imageUrl") as? String  ?? "")
                placesFetched.append(addingPlace)
                
            }
            DispatchQueue.main.async {
                self.placeslist = placesFetched
                self.placesTable.reloadData()
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
}


extension MyPlacesVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeslist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlaceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "placeCell") as! PlaceTableViewCell
        cell.lblTitle.text = self.placeslist[indexPath.row].title ?? ""
        cell.imgPlace.layer.cornerRadius = 30.0
        cell.imgPlace.image = nil
        if let img = self.placeslist[indexPath.row].imageUrl {
            cell.imgPlace.kf.setImage(with: URL(string: "http://35.154.73.71/api/v1\(img)"));
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPlace = placeslist[indexPath.row]
        performSegue(withIdentifier: "ToPlaceDetailsFromMyPlaces", sender: self)
    }
    
}
