//
//  APIManager.swift
//  YuluTest
//
//  Created by Saraswati C on 20/10/19.
//  Copyright © 2019 company. All rights reserved.
//

import Foundation

class APIManager {
    
    let baseURL = "https://jsonplaceholder.typicode.com"
    static let sharedInstance = APIManager()
    static let getPostsEndpoint = "/posts/"
    
    private init() {
    }
    
    
    func getPlaces(onSuccess: @escaping([Place]) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = "http://35.154.73.71/api/v1/places"
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    let places = json as? [Dictionary<String, Any>] ?? []
                    var placesList:[Place] = [];
                    for place in places {
                        let newPlace: Place = Place(id: place["id"] as? String, title: place["title"] as? String, description: "", latitude: place["latitude"] as? Double, longitude: place["longitude"] as? Double, imageUrl: place["imageUrl"] as? String)
                        placesList.append(newPlace)
                    }
                    onSuccess(placesList)
                } catch let err {
                    print("Err", err)
                }
            }
        })
        task.resume()
    }
    
    func getPlaceDetailsUsingId(placeId: String, onSuccess: @escaping(Place) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = "http://35.154.73.71/api/v1/places/\(placeId)"
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    let place = json as? Dictionary<String, Any> ?? [:]
                    
                    let newPlace: Place = Place(id: place["id"] as? String, title: place["title"] as? String, description: place["description"] as? String, latitude: place["latitude"] as? Double, longitude: place["longitude"] as? Double, imageUrl: place["imageUrl"] as? String)
                    
                    onSuccess(newPlace)
                } catch let err {
                    print("Err", err)
                }
            }
        })
        task.resume()
    }
    
    
    func updatePlaceDetailsUsingId(placeId: String, title:String, description:String, latitude:Double, longitude:Double, imgUrl:String, onSuccess: @escaping(Place) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = "http://35.154.73.71/api/v1/places/\(placeId)"
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let json: [String: Any] = ["title": title,
                                   "latitude": latitude,
                                   "longitude": longitude,
                                   "imageUrl" : imgUrl,
                                   "description": description ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    let place = json as? Dictionary<String, Any> ?? [:]
                    
                    let newPlace: Place = Place(id: place["id"] as? String, title: place["title"] as? String, description: place["description"] as? String, latitude: place["latitude"] as? Double, longitude: place["longitude"] as? Double, imageUrl: place["imageUrl"] as? String)
                    
                    onSuccess(newPlace)
                } catch let err {
                    print("Err", err)
                }
            }
        })
        task.resume()
        
    }
    
    func addNewPlaceDetails(title:String, description:String, latitude:Double, longitude:Double, imgUrl:String, onSuccess: @escaping(Place) -> Void, onFailure: @escaping(Error) -> Void) {
        let url : String = "http://35.154.73.71/api/v1/places"
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let json: [String: Any] = ["title": title,
                                   "latitude": latitude,
                                   "longitude": longitude,
                                   "imageUrl" : imgUrl,
                                   "description": description ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    let place = json as? Dictionary<String, Any> ?? [:]
                    
                    let newPlace: Place = Place(id: place["id"] as? String, title: place["title"] as? String, description: place["description"] as? String, latitude: place["latitude"] as? Double, longitude: place["longitude"] as? Double, imageUrl: place["imageUrl"] as? String)
                    
                    onSuccess(newPlace)
                } catch let err {
                    print("Err", err)
                }
            }
        })
        task.resume()
    }
    
    

}
