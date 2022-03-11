//
//  Place.swift
//  TravelBook
//
//  Created by Muhammed Sefa Biçer on 2.03.2022.
//

import Foundation

class Place {
    
    var id: UUID?
    var placeName: String?
    var cityName: String?
    var type: String?
    var description: String?
    var image: Data?
    var latitude: Double?
    var longitude: Double?
    
    
    init(id:UUID,placeName:String,cityName:String,type: String,description: String,image:Data,latitude:Double, longitude:Double){
      
        self.id = id
        self.placeName = placeName
        self.cityName = cityName
        self.type = type
        self.description = description
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
    }

}
