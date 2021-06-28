//
//  FriendsViewController.swift
//  Final Project
//
//  Created by מוטי שקורי on 28/05/2021.
//

import UIKit
import FirebaseDatabase
class FriendsViewController: UIViewController {
    var ref: DatabaseReference!
    var users: [User] = []
    //var friendsRequsets: [FriendRequest] = []
    var currentUser: User!
    var userId: String!
    
    var frame : CGRect!
    @IBOutlet weak var fp_TBV_tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fp_TBV_tableView.estimatedRowHeight = 60
        fp_TBV_tableView.rowHeight = UITableView.automaticDimension
  

        ref = Database.database().reference()
        readUserFromFb()
      
        // Do any additional setup after loading the view.
    }
    func readUserFromFb(){
      
        ref.child("users").observeSingleEvent(of: .value, with: { [self] snapshot in
            if(snapshot.value is NSNull ) {

                 // DATA WAS NOT FOUND
                 print("– – – Data was not found – – –")

              }
            self.getUserId()
            for snap in snapshot.children{
                let snapshotValue = (snap as! DataSnapshot).value as! [String: Any]
                if(self.userId != snapshotValue["id"] as? String){
                self.users.append(User(snapshot: snap as! DataSnapshot))
                }else{
                    self.currentUser = User(snapshot: snap as! DataSnapshot)
                }
            }
            
            self.initView()

               }) { (error) in
                   print(error.localizedDescription)
               }
    }
    
    func getUserId(){
        userId = UserDefaults.standard.value(forKey: "userId") as? String
    }
    

    func initView(){
        fp_TBV_tableView.delegate=self
        fp_TBV_tableView.dataSource=self


        fp_TBV_tableView.register(UINib(nibName: "friendsCell", bundle: nil), forCellReuseIdentifier: "MyCellClass")
        frame = CGRect(x: 10, y: 10, width: self.view.frame.width - 100, height: 30)
    }

}

extension FriendsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
extension FriendsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    if indexPath.row == 0{
    //.... return height whatever you want for indexPath.row
    return 90
    }else {
    return 90
    }
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var flag = false
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellClass", for:indexPath) as! FriendsCell
        if(users[indexPath.row].id != currentUser.id){
      //      let us = users[indexPath.row]
            cell.fc_LBL_name.text = users[indexPath.row].name
        cell.fc_LBL_carNumber.text = users[indexPath.row].carNumber
            cell.reciver = users[indexPath.row]
            
        for i in 0..<currentUser.friends.count{
            if(users[indexPath.row].id == currentUser.friends[i]){
                flag = true
                cell.fc_IMV_statusImage.image = UIImage(named: "check")
                
                cell.fc_BTN_add.isHidden = true
                
            }
        }
        if(flag != true){
        
            for user in users {
                for senderUser in user.friendsRequests{
            if(currentUser.id == senderUser){
                flag = true
                cell.fc_IMV_statusImage.image = UIImage(named: "sand-clock")
            }
          }
        }
        }
        if(flag != true){
            
            cell.fc_IMV_statusImage.image = UIImage(named: "user")
    
    }
            //cell.fc_IMV_statusImage.frame = CGRectMake(0,0,32,32);
        }
        return cell
}

    
}
