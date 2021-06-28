//
//  ParkingViewController.swift
//  Final Project
//
//  Created by מוטי שקורי on 03/06/2021.
//
import FirebaseDatabase
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import UIKit
import MobileCoreServices
import FirebaseStorage


class ParkingViewController: UIViewController {
    
    var ref: DatabaseReference!
    var pp_TXF_carNumber: MDCFilledTextField!
    @IBOutlet weak var pp_TXF_description: UITextField!
    private var user:User!
    private var lat: Double = 0.0
    private var lon: Double = 0.0
    private var date:String!
    private var fileName:String = ""
    @IBOutlet weak var pp_BTN_carImage: UIButton!
    var carNumber: String!
    var strDate:String!
    @IBOutlet weak var pp_DP_datePicker: UIDatePicker!
    var callback : (() -> Void)?
    override func viewDidDisappear(_ animated : Bool) {
        super.viewDidDisappear(animated)
        writeJson()
        callback?()
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readUser()
        initView()

    }
    func initView(){
        let estimatedFrame2 = CGRect(x: 10, y:500, width:  UIScreen.main.bounds.width-20, height: 50)
        pp_TXF_carNumber = MDCFilledTextField(frame: estimatedFrame2)
        pp_TXF_carNumber.label.text = "Car Number"
        pp_TXF_carNumber.placeholder = user.carNumber
        pp_TXF_carNumber.leadingAssistiveLabel.text = "This is helper text"
        pp_TXF_carNumber.sizeToFit()
        view.addSubview(pp_TXF_carNumber)
        ref = Database.database().reference()
        
       initDate()
        date = strDate
    }
    
    func writeJson(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(self.user)
        let temp :String = String(data: data, encoding: .utf8)!
        UserDefaults.standard.setValue(temp, forKey: "currentUser")
        
    }
    
    
    func initDate(){
        let dateFormatter = DateFormatter()

         dateFormatter.dateStyle = DateFormatter.Style.short
         dateFormatter.timeStyle = DateFormatter.Style.short
        strDate = dateFormatter.string(from: pp_DP_datePicker.date)
    }
    @IBAction func valueDateChanged(_ sender: Any) {
            initDate()
         date = strDate
    }
    @IBAction func saveParking(_ sender: Any) {
     
        if(pp_TXF_carNumber.text != ""){
            carNumber = pp_TXF_carNumber.text
        }else{
            carNumber = pp_TXF_carNumber.placeholder
        }
        if(pp_BTN_carImage != UIImage(named: "photo.on.rectangle.fill")){
            print()
        }
        readLocations()
        user.places.append(Place(description: pp_TXF_description.text!,carNumber: carNumber, lat:lat,lon:lon,date:date, imageURL: self.fileName))
        var arrPlaces : [Dictionary<String, Any> ] = []
        for place in user.places{
            arrPlaces.append(place.toDictionary())
        }
        self.ref.child("users").child(user.id).updateChildValues(
            ["places": arrPlaces])
        print(date as Any)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func readUser(){
       // print(UserDefaults.standard.object(forKey:"player") as! [String : AnyObject])
        let temp = UserDefaults.standard.string(forKey:"currentUser")
        if let safePlayer = temp{
            let decoder = JSONDecoder()
            let data = Data(safePlayer.utf8)
            do{
                user = try decoder.decode(User.self, from: data)
                
            }catch{}
        }

    }
    func readLocations(){
        
        if let tempLat = UserDefaults.standard.value(forKey: "lat") {
            lat = tempLat as! Double
            print(" lat \(lat)")
        }
        if let tempLon = UserDefaults.standard.value(forKey: "lon"){
            lon = tempLon as! Double
            print(" lat \(lon)")
        }
        UserDefaults.standard.removeObject(forKey: "lat")
        UserDefaults.standard.removeObject(forKey: "lon")
    }
    
    @IBAction func pp_BTN_clickOnImage(_ sender: Any) {
        storage()
    }
    
    func storage(){
        let imageMediaType = kUTTypeImage as String

        // Define and present the `UIImagePickerController`
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = [imageMediaType]
        pickerController.delegate = self
      
        present(pickerController, animated: true, completion: nil)
      
    }
    func uploadFile(fileUrl: URL) {
      do {
        // Create file name
        let fileExtension = fileUrl.pathExtension
        let identifier = UUID()
         fileName = "\(identifier).\(fileExtension)"
            let metaData = StorageMetadata()
        let storageReference = FirebaseStorage.Storage.storage().reference().child(fileName)
        let currentUploadTask = storageReference.putFile(from: fileUrl, metadata: metaData) { (storageMetaData, error) in
          if let error = error {
            print("Upload error: \(error.localizedDescription)")
            return
          }
                                                                                    
          // Show UIAlertController here
            print("Image file: \(self.fileName) is uploaded! View it at Firebase console!")
                                                                                    
          storageReference.downloadURL { (url, error) in
            if let error = error  {
              print("Error on getting download url: \(error.localizedDescription)")
              return
            }
            print("Download url of \(self.fileName) is \(url!.absoluteString)")
          }
        }
      } catch {
        print("Error on extracting data from url: \(error.localizedDescription)")
      }
    }



}

extension ParkingViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      // Check for the media type
      let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
      if mediaType == kUTTypeImage {
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        
        uploadFile(fileUrl: imageURL)
        // Handle your logic here, e.g. uploading file to Cloud Storage for Firebase
      }
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                //imageView.contentMode = .scaleAspectFit
            pp_BTN_carImage.setImage(pickedImage, for: .normal)
            }
      picker.dismiss(animated: true, completion: nil)
    }
}
