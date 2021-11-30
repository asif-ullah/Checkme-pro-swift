//
//  UserListVc.swift
//  CheckMeDeviceIntegration
//
//  Created by apple on 10/25/21.
//

import Foundation
import UIKit
class UserListVc : UIViewController{
    var userArray : NSArray = []
    @IBOutlet weak var tbllist: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    func setUserArray(_ userArray: [NSArray]?) {
        self.userArray = userArray as! NSArray
    }
}
extension UserListVc : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = "userListCell"
    var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
    if cell == nil {
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
    }
    let u = userArray[indexPath.row]
    if  type(of: u) == VTProUser.self {
        let user = u as? VTProUser
        let imagePath = Bundle.main.path(forResource: "VTProLibBundle", ofType: "bundle")
        let imageBundle = Bundle(path: imagePath ?? "")
        var image: UIImage? = nil
        if let iconID = user?.iconID {
            image = UIImage(contentsOfFile: imageBundle?.path(forResource: "ico\(iconID)", ofType: "png") ?? "")
        }
        let imageSize = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let imageRect = CGRect(x: 0.0, y: 0.0, width: imageSize.width, height: imageSize.height)
        image!.draw(in: imageRect)
        cell?.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetImageFromCurrentImageContext()
        cell?.textLabel?.text = user?.userName
        cell?.detailTextLabel?.text = "\(user!.userID)"
    }else{
        let xuser = u
        cell?.textLabel?.text = (xuser as AnyObject).userName
        cell?.detailTextLabel?.text = (xuser as AnyObject).patientID
    }
    return cell!
   }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

