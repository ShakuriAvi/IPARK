//
//  friendsCell.swift
//  Final Project
//
//  Created by מוטי שקורי on 30/05/2021.
//

import UIKit
import FirebaseDatabase
class FriendsCell: UITableViewCell {

    @IBOutlet weak var fc_BTN_add: UIButton!
    @IBOutlet weak var fc_IMV_statusImage: UIImageView!
    @IBOutlet weak var fc_LBL_carNumber: UILabel!
    @IBOutlet weak var fc_LBL_name: UILabel!
    var reciver: User!
    var currentUser: User!
    private let database =  Database.database().reference()
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
        getCurrentUser()
        // Initialization code
    }
    func initView(){
        if(fc_IMV_statusImage.image == UIImage(named: "sand-clock")){
            fc_BTN_add.isHidden = true
         
        }
        
    }
    func getCurrentUser(){
       // print(UserDefaults.standard.object(forKey:"player") as! [String : AnyObject])
        let temp = UserDefaults.standard.string(forKey:"currentUser")
        if let safePlayer = temp{
            let decoder = JSONDecoder()
            let data = Data(safePlayer.utf8)
            do{
                currentUser = try decoder.decode(User.self, from: data)
                
            }catch{}
        }
    }
    func addRequest(){
    
        reciver.friendsRequests.append(currentUser.id)
        self.database.child("users").child(reciver.id).updateChildValues(["friendsRequests": reciver.friendsRequests])
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func clickOnAdd(_ sender: Any) {
        fc_IMV_statusImage.image =  UIImage(named: "sand-clock")
        fc_BTN_add.isHidden = true
        addRequest()
    }
    
}

