//
//  FriendsRequest.swift
//  Final Project
//
//  Created by מוטי שקורי on 30/05/2021.
//
//import Firebase
import Foundation
class FriendRequest: Codable {
    var sender: [String]
//    init(snapshot: DataSnapshot) {
//        let snapshotValue = snapshot.value as! [String]
//        self.sender = snapshotValue["sender"] as! [String]
//    }
    init(reciver:String,sender: [String]){
        self.sender = sender
 
        
    }
    init(friendsRequests: FriendRequest){
        self.sender = friendsRequests.sender

    }
    
    func toDictionary() -> Dictionary<String, Any> {
     
        
        return [
            "sender": sender,

        ]
    }
    
    required init?(coder aDecoder: NSCoder){
      sender = aDecoder.decodeObject(forKey: "sender") as? [String] ?? [" "]
       
    }
    
    func encode(with aCoder : NSCoder){
        aCoder.encode(sender, forKey: "sender")
    }
}
