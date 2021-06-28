//
//  SettingsViewController.swift
//  Final Project
//
//  Created by מוטי שקורי on 28/05/2021.
//

import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import DropDown
import UIKit
import FirebaseDatabase

class SettingsViewController: UIViewController, UIAlertViewDelegate {
    var ref: DatabaseReference!
    var dropMenu = DropDown()
    var sp_TXF_userName: MDCFilledTextField!
    var sp_TXF_carNumber: MDCFilledTextField!
    @IBOutlet weak var sp_SV_stackView: UIStackView!
    private let database = Database.database().reference()
    private var user:User!
    private var userId:String!
    private var friends: [String] = []
    private var users: [User] = []
    var usersSeen = [String: Bool]()
    //private var userId:String!
    private var stackView:UIStackView!
    private var stackViewArr:[UIStackView] = []
    private var count:Int = 1
    private var button: RemoveButton!
    private var buttonArr:[UIButton] = []
    private var label:UILabel!
    private var labelArr:[UILabel] = []
    @IBOutlet weak var sp_DM_vvdropMenu: UIView!
    var callback : (() -> Void)?
    override func viewDidDisappear(_ animated : Bool) {
        super.viewDidDisappear(animated)
        writeJson()
        callback?()
     
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
   
        readUsersFromFb()


        // Do any additional setup after loading the view.
    }
   
    func readUsersFromFb(){
        self.getUserId()
        ref.child("users").child(userId).observeSingleEvent(of: .value, with: { [self] snapshot in
            if(snapshot.value is NSNull ) {

                 // DATA WAS NOT FOUND
                 print("– – – Data was not found – – –")

            }else{
            self.user =  User(snapshot: snapshot as! DataSnapshot)
            }
//            for snap in snapshot.children{
//                let snapshotValue = (snap as! DataSnapshot).value as! [String: Any]
//                if(self.userId != snapshotValue["id"] as? String){
//                self.users.append(User(snapshot: snap as! DataSnapshot))
//                }else{
//                    self.user = User(snapshot: snap as! DataSnapshot)
//                }
//            }
            
            self.textFieldDesign()
            self.getFriendsPermissions()
            for us in usersSeen{
                if(us.key != ""){
                    self.addElementToLocationsArr(name: us.key)
                }
            }
            
               }) { (error) in
                   print(error.localizedDescription)
               }
    }
    
    func textFieldDesign(){
        let estimatedFrame1 = CGRect(x: 10, y:160, width:  UIScreen.main.bounds.width-20, height: 40)
        sp_TXF_userName = MDCFilledTextField(frame: estimatedFrame1)
        sp_TXF_userName.label.text = "Name"
        sp_TXF_userName.placeholder = user.name
       // sp_TXF_userName.leadingAssistiveLabel.text = "This is helper text"
        sp_TXF_userName.sizeToFit()
        
        let estimatedFrame2 = CGRect(x: 10, y:230, width:  UIScreen.main.bounds.width-20, height: 40)
        sp_TXF_carNumber = MDCFilledTextField(frame: estimatedFrame2)
        sp_TXF_carNumber.label.text = "Car Number"
        sp_TXF_carNumber.placeholder = user.carNumber
       // sp_TXF_carNumber.leadingAssistiveLabel.text = "This is helper text"
        sp_TXF_carNumber.sizeToFit()
        
        view.addSubview(sp_TXF_userName)
        view.addSubview(sp_TXF_carNumber)

    }
    func getUserId(){
        userId = UserDefaults.standard.value(forKey: "userId") as? String
    }
    @IBAction func showFriends(_ sender: Any) {
        dropMenu.show()
    }
    
    func writeJson(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(self.user)
        let temp :String = String(data: data, encoding: .utf8)!
        UserDefaults.standard.setValue(temp, forKey: "currentUser")
        
    }


    func getFriendsPermissions(){
        let temp = UserDefaults.standard.string(forKey:"users")
        if let safeUsers = temp{
            let decoder = JSONDecoder()
            let data = Data(safeUsers.utf8)
            do{
                users = try decoder.decode([User].self, from: data)
                
            }catch{}
        }
     //   UserDefaults.standard.removeObject(forKey: user.name)
        self.usersSeen = UserDefaults.standard.value(forKey: user.name) as? [String:Bool] ?? ["":true]
        print(self.usersSeen.count)
        for id in user.friends{
            for us in users {
                if(id != user.id && us.id == id && usersSeen[us.name] == nil){
                    usersSeen[us.name] = true
                    
                    }
                }
            }
                    
        }
    
    func addElementToLocationsArr(name: String){
        button = RemoveButton()
      //  button.setTitle("Remove", for: .normal)
        if(usersSeen[name] == true){
            button.setImage(UIImage(named: "עין"), for: .normal)
        }
        else{
            button.setImage(UIImage(named: "עין סגורה"), for: .normal)
        }
        label = UILabel()
        label.text = name
        stackView = UIStackView(frame: self.view.bounds)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        initUISelected()
        label.tag = count
        button.tag = count
        stackView.tag = count
        count+=1
        initUISelected()
        }
    func initUISelected(){
        self.stackViewArr.append(stackView)
        self.buttonArr.append(button)
        button.addTarget(self, action: #selector(self.removeClick(_:)), for: UIControl.Event.touchUpInside)
        self.labelArr.append(label)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        stackView.sizeToFit()
        self.sp_SV_stackView.addArrangedSubview(stackView)
    }
    @IBAction func removeClick(_ sender: UIButton) {
        var index = sender.tag
        if (buttonArr[index].currentImage == UIImage(named: "עין סגורה")){
            buttonArr[index].setImage(UIImage(named: "עין"), for: .normal)
            usersSeen[labelArr[index].text!] = true
            print(labelArr[index].text!)
        }else{
            buttonArr[index].setImage(UIImage(named: "עין סגורה"), for: .normal)
            print(labelArr[index].text!)
            usersSeen[labelArr[index].text!] = false
        }
    }

    func saveFriendsPermissions(){
        UserDefaults.standard.set(usersSeen,forKey: user.name)
    }
 
    @IBAction func saveData(_ sender: Any) {
        saveFriendsPermissions()
        if(user.id == ""){
            showAlert(message: "message with connection to user")
        }
        else if(sp_TXF_userName.text == "" && sp_TXF_userName.placeholder == ""){
            showAlert(message: "Name cannot be Empty")
        }
        
        else{
            if(sp_TXF_userName.text != ""){
                
                self.user.name = sp_TXF_userName.text!
                
                database.child("users").child(user.id).updateChildValues(["name" : sp_TXF_userName.text as Any])
            }
            if(sp_TXF_carNumber.text != ""){
                self.user.carNumber = sp_TXF_carNumber.text!
                database.child("users").child(user.id).updateChildValues(
                    ["carNumber" :   sp_TXF_carNumber.text as Any])
            }
      
            _ = navigationController?.popViewController(animated: true)
            
        }
    }
    func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    

    

    
}
