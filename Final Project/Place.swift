//
//  Place.swift
//  Final Project
//
//  Created by מוטי שקורי on 29/05/2021.
//

import Foundation
class Place : Codable{
    var description: String
    var carNumber:String
    var lat:Double
    var lon:Double
    var date: String
    var imageURL: String
    init(description: String,carNumber:String, lat:Double,lon:Double,date:String,imageURL: String){
        self.description=description
        self.carNumber=carNumber
        self.lat=lat
        self.lon=lon
        self.date = date
        self.imageURL = imageURL
    }
    func toDictionary() -> Dictionary<String, Any> {
     
        
        return [
            "description" : description,
            "carNumber": carNumber,
            "lat": lat,
            "lon":lon,
            "date":date,
            "imageURL":imageURL
        ]
    }
    
    required init?(coder aDecoder: NSCoder){
        description = aDecoder.decodeObject(forKey: "description") as? String ?? ""
        carNumber = aDecoder.decodeObject(forKey: "carNumber") as? String ?? ""
        lat = aDecoder.decodeObject(forKey: "lat") as? Double ?? 0.0
        lon = aDecoder.decodeObject(forKey: "lon") as? Double ?? 0.0
        date = aDecoder.decodeObject(forKey: "date") as? String ?? ""
        imageURL = aDecoder.decodeObject(forKey: "imageURL") as? String ?? ""
    }
    
    func encode(with aCoder : NSCoder){
        aCoder.encode(description, forKey: "description")
        aCoder.encode(carNumber, forKey: "carNumber")
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(lon, forKey: "lon")
        aCoder.encode(date,forKey: "date")
        aCoder.encode(date,forKey: "imageURL")
    }
}
