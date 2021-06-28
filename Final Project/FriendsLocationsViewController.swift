//
//  FriendsLocationsViewController.swift
//  Final Project
//
//  Created by מוטי שקורי on 05/06/2021.
//

import UIKit
import MapKit

class FriendsLocationsViewController: UIViewController {

    @IBOutlet weak var flv_TBV_tableView: UITableView!
    @IBOutlet weak var flv_MAP_mapView: MKMapView!
    private var friendsPermissions : [String] = []
    private var users: [User] = []
    private var user : User!
    private var places : [Place] = []
    
    private var userNames : [String] = []
    var usersSeen = [String: Bool]()
    var flag = false
    var annotation :MKPointAnnotation!
    var callback : (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriendsPermissions()
        initView()
        initPlaces()
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated : Bool) {
        super.viewDidDisappear(animated)
        callback?()
    }
    func initPlaces(){
        for temp in users{
            if usersSeen[temp.name] == true {
                for place in temp.places{
                    if(place.date != ""){
                        places.append(place)
                        userNames.append(temp.name)
                    }
                }
            }
        }
    }
    func getFriendsPermissions(){
        var temp = UserDefaults.standard.string(forKey:"currentUser")
        if let safeUser = temp{
            let decoder = JSONDecoder()
            let data = Data(safeUser.utf8)
            do{
                user = try decoder.decode(User.self, from: data)
                
            }catch{}
        }
        temp = UserDefaults.standard.string(forKey:"users")
        if let safeUsers = temp{
            let decoder = JSONDecoder()
            let data = Data(safeUsers.utf8)
            do{
                users = try decoder.decode([User].self, from: data)
                
            }catch{}
        }
        
        self.usersSeen = UserDefaults.standard.value(forKey: user.name) as? [String:Bool] ?? ["":true]
        
    }
    func initView(){
        flv_TBV_tableView.delegate = self
        flv_TBV_tableView.dataSource = self
        flv_TBV_tableView.register(UINib(nibName: "placeCell", bundle: nil), forCellReuseIdentifier: "myPlaceCellClass")
    }


}
extension FriendsLocationsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var location : CLLocationCoordinate2D!
        if places[indexPath.row].lat != 0.0 && places[indexPath.row].lon != 0.0{
             location = CLLocationCoordinate2D(latitude: Double(places[indexPath.row].lat), longitude: Double(places[indexPath.row].lon))
        }else{
            let randomFloat = Float.random(in: 32..<33)
             location = CLLocationCoordinate2D(latitude: Double(randomFloat), longitude: 34.776361)
        }

        if(flag != true){
           annotation = MKPointAnnotation()
            flag = true
            }
        else{
    self.flv_MAP_mapView.removeAnnotation(annotation)
        }
        annotation.title = "Name:\(self.userNames[indexPath.row]), Car number: \(places[indexPath.row].carNumber), At:  \(places[indexPath.row].date)"
        flv_MAP_mapView.addAnnotation(annotation)
        UIView.animate(withDuration: 1.0) {
            self.annotation.coordinate = location
        }
        let viewRegion = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
        flv_MAP_mapView.setRegion(viewRegion, animated: true)
       
    }
    
}
extension FriendsLocationsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myPlaceCellClass", for:indexPath) as! placeCell
      //      let us = users[indexPath.row]
            cell.pc_LBL_name.text = "Name: \(userNames[indexPath.row])"
        cell.pc_LBL_carNumber.text = "Car Number: \(places[indexPath.row].carNumber)"
        cell.pc_LBL_date.text = "Date: \(places[indexPath.row].date)"
        cell.setImage(URL:  places[indexPath.row].imageURL)
        cell.pc_LBL_description.text = places[indexPath.row].description
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    if indexPath.row == 0{
    //.... return height whatever you want for indexPath.row
    return 160
    }else {
    return 160
    }
    }
}
