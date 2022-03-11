//
//  Place.swift
//  TravelBook
//
//  Created by Muhammed Sefa Biçer on 2.03.2022.
//

import Foundation

class Place {
    
    var placeName: String
    var cityName: String
    var type: String
    var image: String
    var imagee: String
    var imageee: String
    
    
    init(placeName:String,cityName:String,type: String,image:String,imagee:String, imageee:String){
      
        self.placeName = placeName
        self.cityName = cityName
        self.type = type
        self.image = image
        self.imagee = imagee
        self.imageee = imageee
    }
    
    
    convenience init(){
        self.init(placeName: "", cityName: "", type: "", image: "", imagee: "", imageee: "")
    } 
}
