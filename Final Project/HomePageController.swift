//
//  HomePageController.swift
//  Final Project
//
//  Created by מוטי שקורי on 25/05/2021.
//
import SideMenu
import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit
import CoreLocation
import FirebaseStorage
import FirebaseUI
import FirebaseAnalytics


class HomePageController: UIViewController, MenuControllerDelegate,CLLocationManagerDelegate  {
    var annotation :MKPointAnnotation!
    @IBOutlet weak var hp_TBV_tableView: UITableView!
    var locationManager: CLLocationManager!
    var flag = false
    @IBOutlet weak var hp_MAP_mapView: MKMapView!
    var sideMenu : SideMenuNavigationController?
    var ref: DatabaseReference!
    private let settingsController = SettingsViewController()
    private let friendsController = FriendsViewController()
    private var friendsRequests: [User] = []
    private var users: [User] = []
    private var user : User!
    private var friendsPermissions : [String] = []
    var lat: Float = 0.0
    var lon: Float = 0.0

    
    override func viewDidLoad() {
           super.viewDidLoad()
      
        readUsersFb()
    
       }
    func initView(){
        
        user.places.remove(at: 0)
        hp_TBV_tableView.delegate = self
        hp_TBV_tableView.dataSource = self
        hp_TBV_tableView.register(UINib(nibName: "placeCell", bundle: nil), forCellReuseIdentifier: "myPlaceCellClass")
    }

    func takeLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location ready")
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            lat = Float(location.coordinate.latitude)
            lon = Float(location.coordinate.longitude)
            print("Locations: \(lat) \(lon)")
  
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
    @IBAction func clickOnButton(_ sender: Any) {
      
        UserDefaults.standard.set(lat,forKey: "lat")
        UserDefaults.standard.set(lon,forKey: "lon")
        self.performSegue(withIdentifier: "goParking", sender: self)
    }
    

    func writeJson(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(self.user)
        let temp :String = String(data: data, encoding: .utf8)!
        UserDefaults.standard.setValue(temp, forKey: "currentUser")
        

        let data2 = try! encoder.encode(self.users)
        let temp2 :String = String(data: data2, encoding: .utf8)!
        UserDefaults.standard.setValue(temp2, forKey: "users")
    
    }
    

    
    //MARK: show popUp
    func getFriendsRequest(){
        
        for i in 0..<self.user.friendsRequests.count{
            if user.friendsRequests[i] != "" {
                getUserRequestFromArr(userID:  user.friendsRequests[i],place: i)
            }
        }
  
    }
    func getUserRequestFromArr(userID:String , place:Int){
       
        for temp in users{
            if( temp.id == userID){
                showPopUp(userRequest: temp, place: place)
            }
        }
        
    }
    func showPopUp(userRequest:User,place:Int){
        let popUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChild(popUp)
        popUp.place = place
        popUp.currentUser = self.user
        popUp.friendUser = userRequest
        popUp.view.frame = self.view.frame
            popUp.popUpData.text = "You got friends Request from: " + userRequest.name + ",\n with car number: " + userRequest.carNumber + ".\n Are you Approve?"
        self.view.addSubview(popUp.view)
        popUp.didMove(toParent: self)
    }
    

    //MARK: show readUsers
  func readUsersFb(){
    ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        UserDefaults.standard.set(userID,forKey: "userId")
    ref.child("users").observeSingleEvent(of: .value, with: { [self] snapshot in
     
        if(snapshot.value is NSNull ) {

             // DATA WAS NOT FOUND
             print("– – – Data was not found – – –")

          }
    for snap in snapshot.children{

        let snapshotValue = (snap as! DataSnapshot).value as! [String: Any]
        if(userID != snapshotValue["id"] as! String){
        self.users.append(User(snapshot: snap as! DataSnapshot))
        }else{
            self.user = User(snapshot: snap as! DataSnapshot)
        }

    }
            print("finishh firebase" + self.user.id)
            self.writeJson()
        if(user.friendsRequests.count > 1){
            self.getFriendsRequest()
        }
        sideMenuInit()
        initView()
        takeLocation()
 //       myGroup.leave()
    }) { (error) in
        print(error.localizedDescription)
    }
    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "goSettings" {
            let destination = segue.destination as!
                SettingsViewController // change that to the real class
            destination.callback = {
                self.updateTable()
            }
        }
           else if segue.identifier == "goParking" {
            let destination = segue.destination as! ParkingViewController
            destination.callback = {
                self.updateTable()
            }
        }
    }
    
    func updateTable(){
        
         print("oops")
        var temp = UserDefaults.standard.string(forKey:"currentUser")
            if let safeUser = temp{
                let decoder = JSONDecoder()
                let data = Data(safeUser.utf8)
                do{
                    self.user = try decoder.decode(User.self, from: data)
                    print(self.user.name)
                }catch{}
            }
            self.user.places.remove(at: 0)
            self.hp_TBV_tableView.reloadData()
           }
      
        
    func sideMenuInit(){
        let menu = MenuController(with: ["Home","Search","Settings","Friends","Logout"])
        sideMenu = SideMenuNavigationController(rootViewController:menu )
        menu.delegate = self
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
   //     addChildControllers()
    }
    func addChildControllers(){
        addChild(settingsController)
        addChild(friendsController)
        
        view.addSubview(settingsController.view)
        view.addSubview(friendsController.view)
        
        settingsController.view.frame = view.bounds
        friendsController.view.frame = view.bounds
        
        settingsController.didMove(toParent: self)
        friendsController.didMove(toParent: self)
   
        settingsController.view.isHidden = true
        friendsController.view.isHidden = true
    }
    @IBAction func didTapMenuNutton(){
        present(sideMenu!, animated: true)
    }
    func logoutUser() {
        // call from any screen
        
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        
        navigationController?.popToRootViewController(animated: true)
    }
    func didSelectMenuItem(named: String) {
        sideMenu?.dismiss(animated: true, completion:{
           // self.title = named
            if named == "Home"{
            }
            else if named == "Search"{
                self.performSegue(withIdentifier: "goAdd", sender: self)
             
            }
            else if named == "Friends"{
                self.performSegue(withIdentifier: "goFriends", sender: self)
             
            }
            else if named == "Settings"{
             
                self.performSegue(withIdentifier: "goSettings", sender: self)
              
            }
            else if named == "Logout"{
                self.logoutUser()
            }
            
        } )
    }


}
extension HomePageController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var location : CLLocationCoordinate2D!
        if user.places[indexPath.row].lat != 0.0 && user.places[indexPath.row].lon != 0.0{
            location = CLLocationCoordinate2D(latitude: Double(user.places[indexPath.row].lat), longitude: Double(user.places[indexPath.row].lon))
        }else{
            let randomFloat = Float.random(in: 32..<33)
             location = CLLocationCoordinate2D(latitude: Double(randomFloat), longitude: 34.776361)
        }

        if(flag != true){
           annotation = MKPointAnnotation()
            flag = true
            }
        else{
    self.hp_MAP_mapView.removeAnnotation(annotation)
        }
        annotation.title = "Name:\(self.user.name), Car number: \(user.places[indexPath.row].carNumber), At:  \(user.places[indexPath.row].date)"
        hp_MAP_mapView.addAnnotation(annotation)
        UIView.animate(withDuration: 1.0) {
            self.annotation.coordinate = location
        }
        let viewRegion = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
        hp_MAP_mapView.setRegion(viewRegion, animated: true)
       
    }
    
}
extension HomePageController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.places.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myPlaceCellClass", for:indexPath) as! placeCell
      //      let us = users[indexPath.row]
  
        cell.pc_LBL_name.text = user.name
        cell.pc_LBL_carNumber.text = "Car Number: " +  user.places[indexPath.row].carNumber
        cell.pc_LBL_date.text = user.places[indexPath.row].date
     
        cell.setImage(URL: user.places[indexPath.row].imageURL)
    
        if user.places[indexPath.row].description == "" {
            cell.pc_LBL_description.isHidden = true
        }else{
            cell.pc_LBL_description.text = user.places[indexPath.row].description
        }
        return cell
}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    if indexPath.row == 0{
    //.... return height whatever you want for indexPath.row
    return 130
    }else {
    return 130
    }
    }
}
