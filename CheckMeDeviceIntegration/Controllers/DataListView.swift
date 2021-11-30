//
//  DataListView.swift
//  CheckMeDeviceIntegration
//
//  Created by apple on 10/25/21.
//

import Foundation
import UIKit
class VTDataList: NSObject {
    var isExpand = false
    var list : NSMutableArray = []
    
    override init() {
        super.init()
        list = NSMutableArray.init(capacity: 10)
        isExpand = false
    }
}
class DataListView : UIViewController, VTProCommunicateDelegate{
    var dataList : NSMutableArray = []
    @IBOutlet weak var tblList: UITableView!
    var userList : NSArray = []
    var dataType = 0
    var index = 0
    var i = 0
    var model_ : NSObject? = nil
    var str = ""
    var user: NSObject? = nil
    var isSingleUser = false
    
    override func viewDidLoad() {
        dataList = NSMutableArray.init(capacity: 10)
        for _ in 0..<userList.count {
            let list = VTDataList()
            dataList.add(list)
            print(dataList)
            i = +1
            
        }
        tblList.tableFooterView = UIView(frame: CGRect.zero)
        VTProCommunicate.sharedInstance().delegate = self
        index = 0
        if dataType == 4 || dataType == 5 || dataType == 8 || dataType == 9 {
            isSingleUser = true
            VTProCommunicate.sharedInstance().beginReadFileList(with: nil, fileType: dataTypeMapToFileType())
        }else{
            downloadList(index)
        }
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // SVProgressHUD.dismiss()
        super.viewWillDisappear(true)
    }
    
    func downloadList(_ index: Int) {
        self.index = index
        if index == userList.count {
            self.index = 0
            tblList.reloadData()
            return
        }
        user = userList[self.index] as! VTProUser
        VTProCommunicate.sharedInstance().beginReadFileList(with: user as! VTProUser, fileType: dataTypeMapToFileType())
    }
    func dataTypeMapToFileType() -> VTProFileType {
        switch dataType {
        case 3:
            return VTProFileTypeDlcList
        case 4:
            return VTProFileTypeEcgList
        case 5:
            return VTProFileTypeSpO2List
        case 6:
            return VTProFileTypeBpList
        case 7:
            return VTProFileTypeBgList
        case 8:
            return VTProFileTypeTmList
        case 9:
            return VTProFileTypeSlmList
        case 10:
            return VTProFileTypePedList
        case 12:
            return VTProFileTypeSpcList
        default:
            break
        }
        return VTProFileTypeNone
    }
    func readComplete(withData fileData: VTProFileToRead) {
        if fileData.fileType == VTProFileTypeDlcList{
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseDlcList_(withFileData: fileData.fileData as Data)
                let list = dataList[index] as! VTDataList
                list.list.addObjects(from: arr!)
                dataList.replaceObject(at: index, with: list)
            }
            index += 1
            downloadList(index)
            
        }else if fileData.fileType == VTProFileTypeEcgList{
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseEcgList_(withFileData: fileData.fileData as Data)
                dataList.addObjects(from: arr!)
                tblList.reloadData()
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeSpO2List {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseSPO2List_(withFileData: fileData.fileData as Data)
                dataList.addObjects(from: arr!)
                tblList.reloadData()
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        } else if (fileData.fileType) == VTProFileTypeBpList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseNIBPList_(withFileData: fileData.fileData as Data)
                let list = dataList[index] as! VTDataList
                list.list.addObjects(from: arr!)
                dataList.replaceObject(at: index, with: list)
                print(arr)
            }
            index += 1
            downloadList(index)
        }else if (fileData.fileType) == VTProFileTypeBgList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseBloodSugerList_(withFileData: fileData.fileData as Data)
                let list = dataList[index] as! VTDataList
                list.list.addObjects(from: arr!)
                dataList.replaceObject(at: index, with: list)
            }
            index += 1
            downloadList(index)
        }else if (fileData.fileType) == VTProFileTypeTmList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseTempList_(withFileData: fileData.fileData as Data)
                dataList.add(arr!)
                tblList.reloadData()
            } else {
                print("Error %ld",fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeSlmList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseSLMList_(withFileData: fileData.fileData as Data)
                dataList.add(arr)
                tblList.reloadData()
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypePedList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parsePedList_(withFileData: fileData.fileData as Data)
                let list = dataList[index] as! VTDataList
                list.list.addObjects(from: arr!)
                dataList.replaceObject(at: index, with: list)
            }
            index += 1
            downloadList(index)
        }else if (fileData.fileType) == VTProFileTypeEcgDetail {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let detail = VTProFileParser.parseEcg_(withFileData: fileData.fileData as Data)
                print("%@", detail)
            } else {
                print("Detail Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeSlmDetail {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let detail = VTProFileParser.parseSLMData_(withFileData: fileData.fileData as Data)
                print("%@", detail)
            } else {
                print("Detail Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeSpcList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let data = fileData.fileData.subdata(with: NSRange(location: 10, length: Int(fileData.fileSize) - 10)) as NSData
                let arr = VTProFileParser.parseRecList_(withFileData: data as Data)
                let list = dataList[index] as! VTDataList
                list.list.addObjects(from: arr!)
                dataList.replaceObject(at: index, with: list)
                
            }
            index += 1
            downloadList(index)
        }
    }
}

extension DataListView : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!isSingleUser) {
            let list = dataList[section] as? VTDataList
            if list?.isExpand == true {
                return list?.list.count ?? 0
            } else {
                return 0
            }
        }
        return dataList.count
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if !isSingleUser{
            return userList.count ?? 0
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "dataListCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        var str = ""
        if !isSingleUser {
            let list = dataList[indexPath.section] as! VTDataList
            model_ = list.list[indexPath.row] as? NSObject
            str = "\t"
        } else {
            
            model_ = dataList[indexPath.row] as? NSObject
        }
        
        let dc = model_?.value(forKey: "dtcDate") as? DateComponents
        
        if self.dataTypeMapToFileType() == VTProFileTypeDlcList || dataTypeMapToFileType() == VTProFileTypeEcgList || dataTypeMapToFileType() == VTProFileTypeSlmList {
            cell?.accessoryType = .disclosureIndicator
        } else {
            cell?.accessoryType = .none
        }
        cell?.textLabel?.text = String(format: "%@%ld-%02ld-%02ld %02ld:%02ld:%02ld", str, Int(dc?.year ?? 0), Int(dc?.month ?? 0), Int(dc?.day ?? 0), Int(dc?.hour ?? 0), Int(dc?.minute ?? 0), Int(dc?.second ?? 0))
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSingleUser {
            let list = dataList[indexPath.row] as! VTDataList
            model_ = list.list[indexPath.row] as? NSObject
        } else {
            model_ = dataList[indexPath.row] as? NSObject
        }
        if dataTypeMapToFileType() == VTProFileTypeEcgList {
            let ecg = model_ as? VTProEcg
            VTProCommunicate.sharedInstance().beginReadDetailFile(with: ecg!, fileType: VTProFileTypeEcgDetail)
        } else if dataTypeMapToFileType() == VTProFileTypeSlmList {
            let slm = model_ as? VTProSlm
            VTProCommunicate.sharedInstance().beginReadDetailFile(with: slm!, fileType: VTProFileTypeSlmDetail)
            
        }else{
            return
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        headerView.backgroundColor = UIColor.systemGroupedBackground
        headerView.tag = section
        let lab = UILabel(frame: CGRect(x: 16, y: 5, width: 300, height: 30))
        lab.font = UIFont.boldSystemFont(ofSize: 20)
        if !isSingleUser {
            lab.text = (userList[section] as AnyObject).userName
        }
        headerView.addSubview(lab)
        let tab_ = UITapGestureRecognizer(target: self, action: #selector(self.tapExpand(_:)))
        headerView.addGestureRecognizer(tab_)
        return headerView
    }
    
    @objc func tapExpand(_ sender: UITapGestureRecognizer) {
        let section = sender.view!.tag
        let list = dataList[section] as! VTDataList
        list.isExpand = !list.isExpand
        dataList.replaceObject(at: index, with: list)
        tblList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
