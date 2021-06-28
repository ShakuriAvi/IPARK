//
//  placeCell.swift
//  Final Project
//
//  Created by מוטי שקורי on 05/06/2021.
//

import UIKit
import FirebaseStorage

class placeCell: UITableViewCell {

    @IBOutlet weak var pc_LBL_description: UILabel!
    @IBOutlet weak var pc_LBL_name: UILabel!
    @IBOutlet weak var pc_LBL_date: UILabel!
    @IBOutlet weak var pc_LBL_carNumber: UILabel!
    @IBOutlet weak var pc_IMV_imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setImage(URL: String!){
        let reference = Storage.storage().reference(withPath: URL)
              reference.getData(maxSize: (5 * 1024 * 1024)) { (data, error) in
                if let _error = error{
                   print(_error)
              } else {
                if let _data  = data {
                   let myImage:UIImage! = UIImage(data: _data)
                     self.pc_IMV_imageView.image = myImage
                }
             }
        }
           }
}
