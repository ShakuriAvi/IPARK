//
//  User.swift
//  Final Project
//
//  Created by מוטי שקורי on 29/05/2021.
//

import Foundation
import Firebase

class User : Codable {
    var id: String
    var name:String
    var carNumber:String
    var friends:[String]
    var places:[Place]
    var friendsRequests:[String]
    init(snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as! [String: Any]
        self.id = snapshotValue["id"] as! String
        self.name =  snapshotValue["name"] as! String
        self.carNumber = snapshotValue["carNumber"] as! String
        self.friends = snapshotValue["friends"] as! [String]
        self.places = [Place]()
        for pl in (snapshotValue["places"] as! [Dictionary<String, Any>]){
            self.places.append (Place(description: pl["description"] as! String ,carNumber: pl["carNumber"] as! String
                                 ,lat: pl["lat"] as! Double
                                      ,lon: pl["lon"] as! Double,date: pl["date"] as! String,imageURL: pl["imageURL"] as! String))
        }
        
        
        self.friendsRequests =  snapshotValue["friendsRequests"] as! [String]
//        for fr in (snapshotValue["friendsRequests"] as! [Dictionary<String, [String]>]){
//            self.friendsRequests.append(FriendRequest(reciver: fr["reciver"] as! String, sender: fr["sender"] as! [String]))
//        }
    }
    required init?(coder aDecoder: NSCoder){
        id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        carNumber = aDecoder.decodeObject(forKey: "carNumber") as? String ?? ""
        friends = aDecoder.decodeObject(forKey: "moves") as? [String] ?? [""]
        places = aDecoder.decodeObject(forKey: "places") as? [Place] ?? [Place(description: "",carNumber: "",lat: 0.0,lon: 0.0,date: "",imageURL: "")]
        friendsRequests = aDecoder.decodeObject(forKey: "friendsRequests") as? [String] ?? [""]
       // friendsRequests = aDecoder.decodeObject(forKey: "friendsRequests") as? FriendRequest ?? FriendRequest(reciver: "",sender: [""])
    }
    
    func encode(with aCoder : NSCoder){
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(carNumber, forKey: "carNumber")
        aCoder.encode(friends, forKey: "friends")
        aCoder.encode(places, forKey: "places")
        aCoder.encode(friendsRequests, forKey: "friendsRequests")
    }
}
