//
//  ExlistVC.swift
//  CheckMeDeviceIntegration
//
//  Created by apple on 10/25/21.
//

import Foundation
import UIKit
class ExlistVC : UIViewController ,VTProCommunicateDelegate{
    var listArray : NSMutableArray = []
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        listArray = [NSMutableArray]() as! NSMutableArray
        tblView.tableFooterView = UIView(frame: CGRect.zero)
        VTProCommunicate.sharedInstance().delegate = self
        VTProCommunicate.sharedInstance().beginReadHistoryList()
        super.viewDidLoad()
    }
    func readComplete(withData fileData: VTProFileToRead) {
        if (fileData.fileType == VTProFileTypeEXHistoryList) {
            if (fileData.enLoadResult == VTProFileLoadResultSuccess) {
                let arr = VTProFileParser.parseHeartCheckList(fileData.fileData as Data)
                listArray.add(arr)
                tblView.reloadData()
            }else{
                print("Error %ld",fileData.enLoadResult)
            }
        }else if (fileData.fileType == VTProFileTypeEXHistoryDetail) {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                VTProFileParser.parseECGDetail(withFileData: fileData.fileData as Data, callBack: { header, ecgContent in
                    // Detail data
                    print("Heart rate is %d", header.hrResult)
                })
            } else {
                print("Detail Error %ld",fileData.enLoadResult)
            }
        }
    }
}
extension ExlistVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    static let tableViewIdentifier = "exListCell"

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewIdentifier = "exListCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: tableViewIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: tableViewIdentifier)
        }
        let model = listArray[indexPath.row] as! VTProEXHistory
        let dc = (model as AnyObject).value(forKey: "dtcDate") as? DateComponents
//        cell.accessoryType = CPListItemAccessoryType(rawValue: UITableViewCell.AccessoryType.disclosureIndicator.rawValue)
//        cell.textLabel?.text = String(format: "%04ld-%02ld-%02ld %02ld:%02ld:%02ld", Int(dc?.year ?? 0), Int(dc?.month ?? 0), Int(dc?.day ?? 0), Int(dc?.hour ?? 0), Int(dc?.minute ?? 0), Int(dc?.second ?? 0))
        return cell!
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ex = listArray[indexPath.row] as! VTProEXHistory
        VTProCommunicate.sharedInstance().beginReadHistoryDetail(ex.recordTime)
    }
}

