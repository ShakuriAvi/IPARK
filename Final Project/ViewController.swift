//
//  ViewController.swift
//  Final Project
//
//  Created by מוטי שקורי on 24/05/2021.
//
import FirebaseAuth
import UIKit
import FirebaseUI
import FirebaseDatabase

class ViewController: UIViewController, UIAlertViewDelegate {
       
  //  @IBOutlet weak var lp_STV_stackViewRegister: UIStackView!
    @IBOutlet weak var lp_TXF_numberCar: UITextField!
    @IBOutlet weak var lp_STV_stackViewLogin: UIStackView!
    @IBOutlet weak var lp_BOX_choiceStatus: UISegmentedControl!
    @IBOutlet weak var lp_TXF_passwordLogin: UITextField!
    @IBOutlet weak var lp_TXF_emailLogin: UITextField!
    @IBOutlet weak var lp_BTN_login: UIButton!
    
    private let database =  Database.database().reference()
    override func viewDidLoad() {
           super.viewDidLoad()
     
       }

    @IBAction func statusSign(_ sender: Any) {
        if(lp_BOX_choiceStatus.selectedSegmentIndex == 0 ){
            lp_TXF_numberCar.isHidden=true
            lp_BTN_login.setTitle("Login", for: .normal)
            
        }else{
            lp_TXF_numberCar.isHidden=false
            lp_BTN_login.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func registerClick(_ sender: Any) {
        if(self.lp_TXF_numberCar.text == nil){
            let alert = UIAlertController(title: "Alert", message: "problem with userId", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
           return
        }
        
        let signUpManager = FirebaseAuthManager()
           if let email = lp_TXF_emailLogin.text, let password = lp_TXF_passwordLogin.text {
               signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                   guard let `self` = self else { return }
                   var message: String = ""
                   if (success) {
                       message = "User was sucessfully created."
                    self.addToRealtimeDb()
                   } else {
                       message = "There was an error."
                   }
                   let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                   alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                   self.present(alertController ,animated: true, completion: nil)
             
               }

           }
     
        
    }
    func addToRealtimeDb(){
        guard let userID = Auth.auth().currentUser?.uid else { return }
      
        let place = Place(description: "",carNumber: "",lat: 0.0,lon: 0.0,date: "",imageURL: "")
        let arrPlaces = [place.toDictionary()]
      //  let request = FriendRequest(reciver: userID, sender: [" "])
      //  let requests = request.toDictionary()
       // arrPlaces.append(place.toDictionary())
        let friends: [String] = [userID]
        let object: [String: Any] = [
            "id":userID,
            "name":"",
            "carNumber":self.lp_TXF_numberCar.text!,
            "friends":friends,
            "places":arrPlaces,
            "friendsRequests":[""],
        ]
        self.database.child("users").child(userID).setValue(object)
        self.performSegue(withIdentifier: "goHome", sender: self)
    }
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    @IBAction func loginClick(_ sender: Any) {
       // let loginManager = FirebaseAuthManager()
        guard let email = lp_TXF_emailLogin.text, let password = lp_TXF_passwordLogin.text  else { return }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (sucess, error) in
            guard let `self` = self else { return }
            var message: String = ""
            if (error == nil) {
                message = "User was sucessfully logged in."
                self.performSegue(withIdentifier: "goHome", sender: self)
            } else {
                message = "There was an error."
            }
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController ,animated: true, completion: nil)
        }
    }
    
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }

}
