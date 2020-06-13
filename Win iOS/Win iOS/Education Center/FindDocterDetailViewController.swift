//
//  FindDocterDetailViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 10/02/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit
import GoogleMaps

class FindDocterDetailViewController: UIViewController {

    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var address_Lbl: UILabel!
    @IBOutlet weak var phoneNum_Lbl: UILabel!
    @IBOutlet weak var mapsView: GMSMapView!
    @IBOutlet weak var tabbar: UITabBar!
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
        
        title_Lbl.text = groupNameDoc
        address_Lbl.text = addressDoc
        phoneNum_Lbl.text = PhoneNumber
        callingApi(str: "View Doctor Details-\(groupNameDoc)")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        phoneNum_Lbl.isUserInteractionEnabled = true
        phoneNum_Lbl.addGestureRecognizer(tap)
        mapsView.camera = GMSCameraPosition.camera(withLatitude: Double(truncating: latDoc), longitude: Double(truncating: longDoc), zoom: 17.0)
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(truncating: latDoc), longitude: Double(truncating: longDoc)))
        let markerImage = UIImage(named: "Marker_25")
        let markerView = UIImageView(image: markerImage)
        marker.iconView = markerView
        marker.title = groupNameDoc
        marker.snippet = addressDoc
        marker.map = mapsView
        
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let str = (phoneNum_Lbl.text)!.replacingOccurrences(of: "-", with: "")
        callingApi(str: "Find Premier Doctor-call-\(str)")
         guard let number = URL(string: "tel://" + str) else { return }
          UIApplication.shared.open(number)
    }
}
