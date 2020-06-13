//
//  Model.swift
//  Win iOS
//
//  Created by ISE10121 on 23/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class Model: NSObject {

}
struct UserDefaultsStored {
    static let emailID = "EmailID"
    static let password = "Password"
    static let UserLogedInOrNot = "UserLoggedInOrNot"
    static let tokenID = "AuthTokenID"
}

struct LoadLoginData {
    static var appRegistered,androidVersion,benefitsOverview,contractIdentified,custCare,dOB,emailID,employer,employerCode,enrolled,fertilityEducationLink,firstName,gender,goal,isRxContract,lastName,latestQuote,logo,memberID,message,mobileNumber,networkProvider,notificationStatus,patientConsentAgreement,phoneNumber,portalTokenID,premiere,profileName,profilePhoto,providerSearchLink,rxEnrolled,secureCode,tokenID,updateApp,videoConsults,welcomeText,iOSVersion, dadiProgram, dadiLink,contactUs, NSP: String!
    static var result: NSNumber!
}
class logindata {
    var appRegistered,androidVersion,benefitsOverview,contractIdentified,custCare,dOB,emailID,employer,employerCode,enrolled,fertilityEducationLink,firstName,gender,goal,isRxContract,lastName,latestQuote,logo,memberID,message,mobileNumber,networkProvider,notificationStatus,patientConsentAgreement,phoneNumber,portalTokenID,premiere,profileName,profilePhoto,providerSearchLink,rxEnrolled,secureCode,tokenID,updateApp,videoConsults,welcomeText,iOSVersion, dadiProgram, dadiLink,contactUs, NSP: String!
    var result : NSNumber!
    init(json: Dictionary<String,AnyObject>) {
        appRegistered = json["AppRegistered"] as? String ?? ""
        androidVersion = json["AndroidVersion"] as? String ?? ""
        benefitsOverview = json["BenefitsOverview"] as? String ?? ""
        contractIdentified = json["ContractIdentified"] as? String ?? ""
        contactUs = json["ContactUs"] as? String ?? ""
        custCare = json["CustCare"] as? String ?? ""
        dOB = json["DOB"] as? String ?? ""
        emailID = json["EmailID"] as? String ?? ""
        employer = json["Employer"] as? String ?? "----"
        employerCode = json["EmployerCode"] as? String ?? "----"
        enrolled = json["Enrolled"] as? String ?? ""
        fertilityEducationLink = json["FertilityEducationLink"] as? String ?? ""
        firstName = json["FirstName"] as? String ?? ""
        gender = json["Gender"] as? String ?? ""
        goal = json["Goal"] as? String ?? ""
        isRxContract = json["IsRxContract"] as? String ?? ""
        lastName = json["LastName"] as? String ?? ""
        latestQuote = json["LatestQuote"] as? String ?? ""
        logo = json["Logo"] as? String ?? ""
        memberID = json["memberID"] as? String ?? ""
        message = json["Message"] as? String ?? ""
        mobileNumber = json["MobileNumber"] as? String ?? ""
        networkProvider = json["NetworkProvider"] as? String ?? ""
        notificationStatus = json["NotificationStatus"] as? String ?? ""
        patientConsentAgreement = json["PatientConsentAgreement"] as? String ?? ""
        phoneNumber = json["PhoneNumber"] as? String ?? ""
        portalTokenID = json["PortalTokenID"] as? String ?? ""
        premiere = json["Premiere"] as? String ?? ""
        profileName = json["ProfileName"] as? String ?? ""
        profilePhoto = json["ProfilePhoto"] as? String ?? ""
        providerSearchLink = json["ProviderSearchLink"] as? String ?? ""
        result = json["Result"] as? NSNumber ?? 0
        rxEnrolled = json["RxEnrolled"] as? String ?? ""
        secureCode = json["SecureCode"] as? String ?? ""
        tokenID = json["TokenID"] as? String ?? ""
        updateApp = json["UpdateApp"] as? String ?? ""
        videoConsults = json["VideoConsults"] as? String ?? ""
        welcomeText = json["WelcomeText"] as? String ?? ""
        iOSVersion = json["iOSVersion"] as? String ?? ""
        dadiProgram = json["DadiProgram"] as? String ?? ""
        dadiLink = json["DadiLink"] as? String ?? ""
        NSP = json["NSP"] as? String ?? ""
        
        LoadLoginData.NSP = NSP
        LoadLoginData.dadiLink = dadiLink
        LoadLoginData.dadiProgram = dadiProgram
        LoadLoginData.androidVersion = androidVersion
        LoadLoginData.appRegistered = appRegistered
        LoadLoginData.benefitsOverview = benefitsOverview
        LoadLoginData.contractIdentified = contractIdentified
        LoadLoginData.custCare = custCare
        LoadLoginData.dOB = dOB
        LoadLoginData.emailID = emailID
        LoadLoginData.employer = employer
        LoadLoginData.employerCode = employerCode
        LoadLoginData.enrolled = enrolled
        LoadLoginData.fertilityEducationLink = fertilityEducationLink
        LoadLoginData.firstName = firstName
        LoadLoginData.gender = gender
        LoadLoginData.goal = goal
        LoadLoginData.isRxContract = isRxContract
        LoadLoginData.lastName = lastName
        LoadLoginData.latestQuote = latestQuote
        LoadLoginData.logo = logo
        LoadLoginData.memberID = memberID
        LoadLoginData.profileName = profileName
        LoadLoginData.message = message
        LoadLoginData.mobileNumber = mobileNumber
        LoadLoginData.networkProvider = networkProvider
        LoadLoginData.notificationStatus = notificationStatus
        LoadLoginData.patientConsentAgreement = patientConsentAgreement
        LoadLoginData.phoneNumber = phoneNumber
        LoadLoginData.portalTokenID = portalTokenID
        LoadLoginData.premiere = premiere
        LoadLoginData.providerSearchLink = providerSearchLink
        LoadLoginData.result = result
        LoadLoginData.rxEnrolled = rxEnrolled
        LoadLoginData.secureCode = secureCode
        LoadLoginData.tokenID = tokenID
        LoadLoginData.updateApp = updateApp
        LoadLoginData.videoConsults = videoConsults
        LoadLoginData.welcomeText = welcomeText
        LoadLoginData.iOSVersion = iOSVersion
        LoadLoginData.contactUs = contactUs
    }
}


class forgotPasswordResult {
    var message: String!
    var result: NSNumber!
    init(json: Dictionary<String,AnyObject>) {
        message = json["Message"] as? String ?? ""
        result = json["Result"] as? NSNumber ?? 0
    }
}

class validationList {
    var selectedDate, time, nurseName, nurseEmail, memberID, slotType, timerDuration, videoRoomName : String!
    
    init(json: Dictionary<String, AnyObject>){
        self.selectedDate = json["SelectedDate"] as? String ?? ""
        self.time = json["Time"] as? String ?? ""
        self.nurseName = json["NurseName"] as? String ?? ""
        self.nurseEmail = json["NurseEmail"] as? String ?? ""
        self.memberID = json["MemberID"] as? String ?? ""
        self.slotType = json["SlotType"] as? String ?? ""
        self.timerDuration = json["TimerDuration"] as? String ?? ""
        self.videoRoomName = json["VideoRoomName"] as? String ?? ""
    }
}

class Appointment {
    var NetworkID: String?, UserName: String?, MemberID: String?, NurseName: String?, ID: String?, Text: String?, Time: String?, Color: String?, SelectedDate: String?, Contract: String?, MemberName: String?, Email: String?, NurseEmail: String?, PatientPhone: String?, ConsultType: String?, ConfCode: String?, SlotType: String?, TimerDuration: String?, VideoRoomName: String?
    
    init() {
    }
}
class educationData {
    var image, name, link: NSArray
    init(json: Dictionary<String, AnyObject>) {
        self.image = (((json["rss"] as! NSDictionary).value(forKey: "channel") as! NSDictionary).value(forKey: "item") as! NSArray).value(forKey: "image") as! NSArray
        self.link = (((json["rss"] as! NSDictionary).value(forKey: "channel") as! NSDictionary).value(forKey: "item") as! NSArray).value(forKey: "link") as! NSArray
        self.name = (((json["rss"] as! NSDictionary).value(forKey: "channel") as! NSDictionary).value(forKey: "item") as! NSArray).value(forKey: "name") as! NSArray
    }
}
class DocList {
    var authNo, cPTDesc, contract, date, docType, emailID, faxID, memberID, pDF_Document: String!
    init(json: Dictionary<String, AnyObject>) {
        self.authNo = json["AuthNo"] as? String ?? ""
        self.cPTDesc = json["CPTDesc"] as? String ?? ""
        self.contract = json["Contract"] as? String ?? ""
        self.date = json["Date"] as? String ?? ""
        self.docType = json["DocType"] as? String ?? ""
        self.emailID = json["EmailID"] as? String ?? ""
        self.faxID = json["FaxID"] as? String ?? ""
        self.memberID = json["MemberID"] as? String ?? ""
        self.pDF_Document = json["PDF_Document"] as? String ?? ""
    }
}

class Utils: NSObject{
    class func getViewController(storyboardName:String, storyboardId:String) -> AnyObject {
        
        let storyboard = UIStoryboard(name:storyboardName, bundle:nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: storyboardId)
        
        return viewController
    }
    class func getStringFromDate(date:Date, format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    class func getDateFromString(dateStr:String, format:String) -> Date {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: dateStr)
        print("getDateFromString \(format) dateStr : \(dateStr) date \(String(describing: date))")

        if(date != nil) {
            return date!
        }
        return  Date()
    }
}

class DoctorLocationLIst: NSObject {
    var address = String()
    var distanceText = String()
    var distanceValue = String()
    var durationText = String()
    var durationValue = String()
    var groupName = String()
    var isStoredData = String()
    var text = String()
    var phoneNumber = String()
    var docLocation = [Doclocation]()
    init(json: [String: Any]) {
        self.address = json["Address"] as? String ?? ""
        self.distanceText = json["DistanceText"] as? String ?? ""
        self.distanceValue = json["DistanceValue"] as? String ?? ""
        self.durationText = json["DurationText"] as? String ?? ""
        self.durationValue = json["DurationValue"] as? String ?? ""
        self.groupName = json["GroupName"] as? String ?? ""
        self.isStoredData = json["IsStoredData"] as? String ?? ""
        self.text = json["Text"] as? String ?? ""
         self.phoneNumber = json["PhoneNumber"] as? String ?? ""
        let docLoc = json["Location"] as? NSDictionary ?? [:]
        if(docLoc.count > 0){
                let latLong = Doclocation.init(json: docLoc as! [String : Any])
                docLocation.append(latLong)
        }
        
    }
}
class Doclocation {
    var latitude : NSNumber!
    var longitude : NSNumber!
    init(json: [String: Any]) {
        self.latitude = json["Latitude"] as? NSNumber ?? 0
        self.longitude = json["Longitude"] as? NSNumber ?? 0
    }
}
