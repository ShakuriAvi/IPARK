//
//  PopUpViewController.swift
//  Final Project
//
//  Created by מוטי שקורי on 02/06/2021.
//
import FirebaseDatabase
import UIKit

class PopUpViewController: UIViewController {
   
    var ref: DatabaseReference!
    var currentUser:User!
    var friendUser:User!
    var place: Int!
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var popUpData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.layer.cornerRadius = 10
        
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    func updatefriends(user:User,secondUser:User){
        user.friends.append(secondUser.id)
        self.ref.child("users").child(user.id).updateChildValues(["friends": user.friends])
    }
    @IBAction func btnClick(_ sender: UIButton) {
        if(sender.tag == 0){
         updatefriends(user: currentUser, secondUser: friendUser)
         updatefriends(user: friendUser, secondUser: currentUser)
            
        }
        currentUser.friendsRequests.remove(at: place)
        self.ref.child("users").child(currentUser.id).updateChildValues(["friendsRequests": currentUser.friendsRequests])
        self.view.removeFromSuperview()
          }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

