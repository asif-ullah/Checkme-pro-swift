//
//  DeviceInformationVc.swift
//  CheckMeDeviceIntegration
//
//  Created by apple on 10/25/21.
//

import Foundation
import UIKit
class DeviceInformationVc : UIViewController{
    
    @IBOutlet weak var infoLabel: UILabel!
    var proInfo: VTProInfo?
    override func viewDidLoad() {
        if proInfo == nil{
            infoLabel.text = "Get device information error"
            return
        }
        print(proInfo?.description)
        infoLabel.text = proInfo?.description
        super.viewDidLoad()
    }
    func setProInfo(_ proInfo: VTProInfo?) {
        self.proInfo = proInfo
    }
}
