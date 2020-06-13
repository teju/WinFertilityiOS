//
//  FindDoctorViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 10/02/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

var groupNameDoc = String()
var addressDoc = String()
var latDoc : NSNumber!
var longDoc : NSNumber!
var PhoneNumber = String()

import UIKit
import GoogleMaps

class FindDoctorViewController: UIViewController, GMSMapViewDelegate, customViewDelegate {
    func cancelBtnAction(sender: AnyObject) {
        self.customView.removeFromSuperview()
    }
    
    func okayBtnAction(sender: AnyObject) {
        self.customView.removeFromSuperview()
    }
    

    @IBOutlet weak var zipCode_Txt: ZWTextField!
    @IBOutlet weak var mapsView: GMSMapView!
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var mile_Txt: ZWTextField!
    @IBOutlet weak var docList: UITableView!
    @IBOutlet weak var mapBtnOutLet: UIButton!
    @IBOutlet weak var listViewBtnClick: UIButton!
    @IBOutlet weak var compnayView: UIView!
    @IBOutlet weak var companyTableView: UITableView!
    @IBOutlet weak var subTitle_Lbl: UILabel!
    
    var btnClickArray = NSMutableArray()
    var imagesArray = NSMutableArray()
    var cameraPosition = GMSCameraPosition()
    var docloactionLIst = [DoctorLocationLIst]()
    
    var milesArray = ["25","50","75","100"]
    var milesstring = ""
    var titleArray = [String]()
    var customView = CustomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(LoadLoginData.contractIdentified == "PWC"){
            self.tabbar.selectedItem = tabbar.items?[1]
                self.tabbar.items![1].image = UIImage(named: "icon-toolbar-family-building")
                self.tabbar.items![1].selectedImage = UIImage(named: "icon-toolbar-family-building-active")
                self.tabbar.items![2].image = UIImage(named: "icon-toolbar-parental")
                self.tabbar.items![2].selectedImage = UIImage(named: "icon-toolbar-parental-active")
                self.tabbar.items![3].image = UIImage(named: "icon-toolbar-benefits-childcare")
                self.tabbar.items![3].selectedImage = UIImage(named: "icon-toolbar-benefits-childcare-active")
                self.tabbar.items![4].image = UIImage(named: "icon-connect")
                self.tabbar.items![4].selectedImage = UIImage(named: "icon-connect-active")
        }else{
            presentIndex = "4"
            self.tabbar.selectedItem = tabbar.items?[3]
        }
        self.customView.customViewDelegates = self
        milesstring = "25"
        mile_Txt.loadDropdownData(data: milesArray)
        mapsView.delegate = self
        self.docList.isHidden = true
        self.mapsView.settings.compassButton = true
        let sydney = GMSCameraPosition.camera(withLatitude: 40.682126,
                                              longitude: -102.473607,
                                                      zoom: 4)
        mapsView.camera = sydney
        if(LoadLoginData.premiere == "Yes"){
            compnayView.isHidden = true
        }else{
            self.companyData()
        }
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func searchBtnClick(_ sender: Any) {
        guard !(zipCode_Txt.text!.isEmpty) else {
            self.customView.loadingData(titleLabl: "", subTitleLabel: "Please check the zip code.", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(customView)
            return
        }
        self.view.endEditing(true)
        mapsView.clear()
        gettingDoctorListApiCall()
    }
    @IBAction func mapViewBtnClick(_ sender: Any) {
        mapBtnOutLet.setTitleColor(UIColor.fromHexaString(hex: "94D60A"), for: UIControl.State.normal)
        listViewBtnClick.setTitleColor(UIColor.fromHexaString(hex: "16284C"), for: UIControl.State.normal)
        mapsView.isHidden = false
        docList.isHidden = true
    }
    @IBAction func listViewBtnClick(_ sender: Any) {
        mapBtnOutLet.setTitleColor(UIColor.fromHexaString(hex: "16284C"), for: UIControl.State.normal)
        listViewBtnClick.setTitleColor(UIColor.fromHexaString(hex: "94D60A"), for: UIControl.State.normal)
        mapsView.isHidden = true
        docList.isHidden = false
    }
    func gettingDoctorListApiCall(){
        docloactionLIst.removeAll()
        var requestDict = [String: String]()
        requestDict["zipcode"] = zipCode_Txt.text
        requestDict["mile"] = milesstring
        ApiCalls(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loadDoctorLocationList.Api, successCallback: {(result) in
            if  let responseDict = result as? NSArray {
                           if responseDict.count > 0{
                               self.titleArray = responseDict.value(forKey: "GroupName") as! [String]
                           for i in 0...responseDict.count - 1 {
                               
                               let locationData = DoctorLocationLIst.init(json: responseDict[i] as! [String : Any])
                               self.docloactionLIst.append(locationData)
                           }
                           print(self.docloactionLIst.count)
                           self.showingMarkerOnMap()
                           self.docList.reloadData()
                           }else{
                               print("There is no data")
                           }
                       }else{
                
                       }
        }, failureCallback: {(error) in
            
        })
    }
    func find(value searchValue: String, in array: [String]) -> Int?
    {
        for (index, value) in array.enumerated()
        {
            if value == searchValue {
                return index
            }
        }

        return nil
    }
     func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
         if let index = find(value: marker.title!, in: titleArray){
             PhoneNumber = docloactionLIst[index].phoneNumber
         }
         groupNameDoc = marker.title!
          addressDoc = marker.snippet!
          latDoc = marker.position.latitude as NSNumber
          longDoc = marker.position.longitude as NSNumber
                let notifications_navigation = Utils.getViewController(storyboardName: "Main", storyboardId: "FindDocterDetailViewController") as! FindDocterDetailViewController
                self.navigationController?.pushViewController(notifications_navigation, animated: true)
     }
    func showingMarkerOnMap() {
        var markerList = [GMSMarker]()
        print(docloactionLIst)
        for i in 0...docloactionLIst.count - 1 {
            mapsView.camera = GMSCameraPosition.camera(withLatitude: Double(truncating: (docloactionLIst[i].docLocation.first?.latitude!)!), longitude: Double(truncating: (docloactionLIst[i].docLocation.first?.longitude)!), zoom: 17.0)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(truncating: (docloactionLIst[i].docLocation.first?.latitude!)!), longitude: Double(truncating: (docloactionLIst[i].docLocation.first?.longitude)!)))
            marker.title = docloactionLIst[i].groupName
            marker.snippet = docloactionLIst[i].address
            marker.icon = drawText(text: "\(i + 1)" as NSString, inImage: UIImage(named: "Marker_25")!)
            marker.map = mapsView
            markerList.append(marker)
        }
        var bounds = GMSCoordinateBounds()
        for marker in markerList {
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds)
        mapsView.moveCamera(update)
    }
    func drawText(text:NSString, inImage:UIImage) -> UIImage? {

            let font = UIFont.systemFont(ofSize: 8)
            let size = inImage.size

            //UIGraphicsBeginImageContext(size)
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
            inImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let style : NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            style.alignment = .center
            let attributes:NSDictionary = [ NSAttributedString.Key.font : font, NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.foregroundColor : UIColor.black ]

            let textSize = text.size(withAttributes: attributes as? [NSAttributedString.Key : Any])
            let rect = CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height)
            let textRect = CGRect(x: (rect.size.width - textSize.width)/2, y: (rect.size.height - textSize.height)/2 - 2, width: textSize.width, height: textSize.height)
            text.draw(in: textRect.integral, withAttributes: attributes as? [NSAttributedString.Key : Any])
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resultImage
    }
}
extension FindDoctorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if(tableView == docList){
            if(docloactionLIst.count > 0){
                return docloactionLIst.count
            }
            }
            if(tableView == companyTableView){
            if (imagesArray.count > 0){
                return imagesArray.count
            }
            }
            return 0
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cells = UITableViewCell()
            if(tableView == docList){
            let cell: FindDoctorTableViewCell = (tableView.dequeueReusableCell(withIdentifier:"DocList", for: indexPath) as? FindDoctorTableViewCell)!
            print(docloactionLIst[indexPath.row].groupName)
            cell.title_Lbl.text = docloactionLIst[indexPath.row].groupName
            cell.subTitle_Lbl.text = docloactionLIst[indexPath.row].address
            cell.indexValue_Lbl.layer.masksToBounds = true
            cell.indexValue_Lbl.text = "\(indexPath.row + 1)"
                cell.indexValue_Lbl.layer.cornerRadius = cell.indexValue_Lbl.bounds.width / 2
                return cell
            }
            if(tableView == companyTableView){
                let cell: FindDoctorSecTableViewCell = (tableView.dequeueReusableCell(withIdentifier:"CellDoctor", for: indexPath) as? FindDoctorSecTableViewCell)!
                cell.img_View.downloadImageFrom(link: imagesArray[indexPath.row] as! String, contentMode: .scaleAspectFit)
    //            cell.img_View.layer.borderWidth = 2
    //            cell.img_View.layer.borderColor = UIColor.fromHexaString(hex: "318DDE").cgColor
                return cell
            }
            return cells
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if(tableView == docList){
            docList.deselectRow(at: indexPath, animated: true)
            groupNameDoc = docloactionLIst[indexPath.row].groupName
            addressDoc = docloactionLIst[indexPath.row].address
            latDoc = docloactionLIst[indexPath.row].docLocation.first?.latitude
            longDoc = docloactionLIst[indexPath.row].docLocation.first?.longitude
                PhoneNumber = docloactionLIst[indexPath.row].phoneNumber
            
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FindDocterDetailViewController") as? FindDocterDetailViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            }
            if(tableView == companyTableView){
                companyTableView.deselectRow(at: indexPath, animated: true)
                if let url = URL(string: btnClickArray[indexPath.row] as! String) {
                    UIApplication.shared.open(url)
                }
            }
        }
    func companyData(){
        var requestDict = [String: String]()
        requestDict["URL"] = LoadLoginData.benefitsOverview
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.getEducationDetails.Api, successCallback: {(result) in
            if let responseDict = result as NSDictionary? {
               print(responseDict)
            if  let listdata = (((((responseDict.value(forKey: "rss") as! NSDictionary).value(forKey: "channel") as! NSDictionary).value(forKey: "item") as! NSDictionary).value(forKey: "providers") as! NSDictionary).value(forKey: "provider") as! NSArray).value(forKey: "providerlogo") as? NSArray {
                self.imagesArray = listdata.mutableCopy() as! NSMutableArray
                self.imagesArray.removeObject(at: 0)
               }
               if   let listdata = (((((responseDict.value(forKey: "rss") as! NSDictionary).value(forKey: "channel") as! NSDictionary).value(forKey: "item") as! NSDictionary).value(forKey: "providers") as! NSDictionary).value(forKey: "provider") as! NSArray).value(forKey: "providerlink") as? NSArray {
                
                self.btnClickArray = listdata.mutableCopy() as! NSMutableArray
                self.btnClickArray.removeObject(at: 0)
               }
            if   let listdata = (((((responseDict.value(forKey: "rss") as! NSDictionary).value(forKey: "channel") as! NSDictionary).value(forKey: "item") as! NSDictionary).value(forKey: "providers") as! NSDictionary).value(forKey: "providertext") as! NSDictionary).value(forKey: "#cdata-section") as? String {
                self.subTitle_Lbl.text = listdata
            }
            }
            self.companyTableView.reloadData()
        }, failureCallback: {(error) in
            
        })
    }
}
class FindDoctorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var subTitle_Lbl: UILabel!
    @IBOutlet weak var indexValue_Lbl: UILabel!
}
class FindDoctorSecTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img_View: UIImageView!
}
