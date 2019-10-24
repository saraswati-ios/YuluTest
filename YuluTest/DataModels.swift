//
//  DataModels.swift
//  YuluTest
//
//  Created by Saraswati C on 20/10/19.
//  Copyright © 2019 company. All rights reserved.
//

import Foundation

struct MyPlacesList: Codable {
    let placesList: [Place]?
}

struct Place: Codable {
    let id: String?
    let title: String?
    let description: String?
    let latitude: Double?
    let longitude: Double?
    let imageUrl: String?
}
