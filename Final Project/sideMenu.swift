//
//  sideMenu.swift
//  Final Project
//
//  Created by מוטי שקורי on 25/05/2021.
//

import Foundation
import UIKit

protocol MenuControllerDelegate {
    func didSelectMenuItem(named: String)
}

class MenuController: UITableViewController {
    
    public var delegate:MenuControllerDelegate?
    
    var images: [String]!
    private let menuItems:[String]
    init(with menuItems: [String]){
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        images = ["house","loupe","settings","friends","exit"]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemPink
        view.backgroundColor = .systemPink
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let image : UIImage = UIImage(named: images[indexPath.row])!
        cell.imageView!.image = image
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.textColor = .darkGray
        cell.backgroundColor = .systemPink
        cell.contentView.backgroundColor = .systemPink
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = menuItems[indexPath.row]
      //  self.performSegue(withIdentifier:menuItems[indexPath.row],sender: self)
        
        delegate?.didSelectMenuItem(named: selectedItem)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
         
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x:0, y:0, width:tableView.bounds.size.width, height:70))
        view.backgroundColor = .systemPink
        let profileImageView = UIImageView(frame: CGRect(x:80, y:5, width:60, height:60)) // Change frame size according to you ..
        profileImageView.image = UIImage(named: "LOGO IPARK לתפריט") //Image set your
    //    let label = UILabel()
    //    label.text = "Welcome"
    //    label.sizeToFit()
    //    label.center = view.center
       // label.textAlignment = NSTextAlignment.
        view.addSubview(profileImageView)
    //    view.addSubview(label)

        return view
    }

}

