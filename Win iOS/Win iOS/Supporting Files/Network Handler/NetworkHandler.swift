//
//  NetworkHandler.swift
//  Win iOS
//
//  Created by BALARAM SOMINENI on 07/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//
import Foundation
import Alamofire



@available(iOS 13.0, *)
let appDelegate = UIApplication.shared.delegate as? AppDelegate
@available(iOS 13.0, *)
let window = appDelegate?.window

//MARK: -Base Url Declaration
enum baseUrl: String {
    case productionApi = "https://trackerapp.winfertility.com/api/"
    case developmentApi = "https://devtrackerapp.winfertility.com/api/"
    case notificationApi = "https://trackerapp.winfertility.com/NotificationApi/"
}
//MARK: -Retrieving the Base Url
struct RootUrl {
    let rootUrl = baseUrl.productionApi.rawValue
    let notificationApi = baseUrl.notificationApi.rawValue
}
//MARK: -Initializing The Method Name To The String
protocol ApiCallMethod {
     var Api: String { get }
}
//MARK: -Declaring The Api Method Names With Base Url
enum ApiMethodsName: ApiCallMethod {
    case loginApi, createAccount, loadEmployerDetails, forgotPassword, changePassword, saveFertilityProfile, loadFertilityProfile, saveMenstrualCycle, saveEvents, loadEvents, requestRefill, saveReminders, deleteReminders, loadReminders, loadReminderEventData, loadCalenderData, loadCycleData, loadUserProfile, sendMyGraphs, exportAccumulator, helpUs, saveFeedback, saveTextMessage, saveNotification, loadNotification, disableNotification, saveFertilityCoach, saveNotificarionStatus, uploadProfilePhoto, loadProviders, sendPushToken, getTokenId, loadNotificationList, saveCallRecorderLog, createATSTask, uploadRxDocument, loadRxPriceQuotes, emailQuote, getQuoteURL, loadAvailableSlots, loadCalenderInfo, saveNurseShedule, validation, validationList, sendMessage, signOut, loadAuth, loadLetter, loadandConvertDocument, loadDoctorLocationList, getAccumulatorDetails, chekingMailId, skipRegistration, getEducationDetails, getTwilioToken
  
    var Api : String {
        switch self {
        case .loginApi: return "\(RootUrl().rootUrl)Login/LoadLogin"
        case .createAccount: return "\(RootUrl().rootUrl)CreateAccount/CreateAccount"
        case .loadEmployerDetails: return "\(RootUrl().rootUrl)CreateAccount/LoadEmployerDetails"
        case .forgotPassword: return "\(RootUrl().rootUrl)ForgotPassword/ForgotPassword"
        case .changePassword: return "\(RootUrl().rootUrl)ForgotPassword/ChangePassword"
        case .saveFertilityProfile: return "\(RootUrl().rootUrl)FertilityProfile/SaveFertilityProfile"
        case .loadFertilityProfile: return "\(RootUrl().rootUrl)FertilityProfile/LoadFertilityProfileData"
        case .saveMenstrualCycle: return "\(RootUrl().rootUrl)MenstrualCycle/SaveMenstrualCycle"
        case .saveEvents: return "\(RootUrl().rootUrl)Event/SaveEvent"
        case .loadEvents: return "\(RootUrl().rootUrl)Event/LoadEventData"
        case .requestRefill: return "\(RootUrl().rootUrl)Profile/RequestRefill"
        case .saveReminders: return "\(RootUrl().rootUrl)Reminder/SaveReminder"
        case .deleteReminders: return "\(RootUrl().rootUrl)Reminder/DeleteReminder"
        case .loadReminders:  return "\(RootUrl().rootUrl)Reminder/LoadReminderData"
        case .loadReminderEventData:  return "\(RootUrl().rootUrl)Reminder/LoadReminderEventData"
        case .loadCalenderData: return "\(RootUrl().rootUrl)MenstrualCycle/LoadMenstrualCycleCalendarData"
        case .loadCycleData: return "\(RootUrl().rootUrl)MenstrualCycle/LoadMenstrualCycleData"
        case .loadUserProfile: return "\(RootUrl().rootUrl)Profile/LoadProfileData"
        case .sendMyGraphs: return "\(RootUrl().rootUrl)Profile/SendMyGraphs"
        case .exportAccumulator: return "\(RootUrl().rootUrl)premier/sendaccumulatorDetails"
        case .helpUs: return "\(RootUrl().rootUrl)Profile/SaveHelpUsContactEmployer"
        case .saveFeedback: return "\(RootUrl().rootUrl)Profile/SaveFeedback?"
        case .saveTextMessage: return "\(RootUrl().rootUrl)Profile/TextMessage"
        case .saveNotification: return "\(RootUrl().rootUrl)Profile/SaveNotifications"
        case .loadNotification: return "\(RootUrl().rootUrl)Profile/LoadNotifications"
        case .disableNotification: return "\(RootUrl().rootUrl)Profile/SavePregnantNotificationStatus"
        case .saveFertilityCoach: return "\(RootUrl().rootUrl)FertilityCoach/SaveFertilityCoach"
        case .saveNotificarionStatus: return "\(RootUrl().rootUrl)Profile/SaveNotificationStatus"
        case .uploadProfilePhoto: return "\(RootUrl().rootUrl)Profile/SaveProfilePhoto"
        case .loadProviders: return "\(RootUrl().rootUrl)ProviderSearch/LoadProviderSearch"
        case .sendPushToken: return "\(RootUrl().rootUrl)CreateAccount/SavePushNotification"
        case .getTokenId: return "\(RootUrl().notificationApi)Notification/GetTokenId"
        case .loadNotificationList: return "\(RootUrl().rootUrl)Notification/LoadNotificationsList"
        case .saveCallRecorderLog: return "\(RootUrl().rootUrl)Event/CallRecoderLog"
        case .createATSTask: return "\(RootUrl().rootUrl)CreateWINRxATSTask/CreateATSTask"
        case .uploadRxDocument: return "\(RootUrl().rootUrl)CreateWINRxATSTask/UploadRxDocument"
        case .loadRxPriceQuotes: return "\(RootUrl().rootUrl)CreateWINRxATSTask/LoadRxPriceQuotes"
        case .emailQuote: return "\(RootUrl().rootUrl)CreateWINRxATSTask/EmailQuote"
        case .getQuoteURL: return "\(RootUrl().rootUrl)CreateWINRxATSTask/GetQuoteURL"
        case .loadAvailableSlots: return "\(RootUrl().rootUrl)NurseConsults/LoadAvailableSlots"
        case .loadCalenderInfo: return "\(RootUrl().rootUrl)NurseConsults/LoadCalendarInfo"
        case .saveNurseShedule: return "\(RootUrl().rootUrl)NurseConsults/SaveNurseSchedule"
        case .validation: return "\(RootUrl().rootUrl)NurseConsults/Validation"
        case .validationList: return "\(RootUrl().rootUrl)NurseConsults/ValidationList"
        case .sendMessage: return "\(RootUrl().rootUrl)AppChat/SendMessage"
        case .signOut: return "\(RootUrl().rootUrl)AppChat/SignOut"
        case .loadAuth: return "\(RootUrl().rootUrl)Letter/LoadAuth"
        case .loadLetter: return "\(RootUrl().rootUrl)Letter/LoadLetter"
        case .loadandConvertDocument: return "\(RootUrl().rootUrl)Letter/LoadandConvertDocument"
        case .loadDoctorLocationList: return "\(RootUrl().rootUrl)ProviderSearch/LoadZipcode"
        case .getAccumulatorDetails: return "\(RootUrl().rootUrl)Premier/LoadAccumulatorHistory"
        case .chekingMailId: return "\(RootUrl().rootUrl)Createaccount/validateemail"
        case .skipRegistration: return "\(RootUrl().rootUrl)Createaccount/infocenter"
        case .getEducationDetails: return "\(RootUrl().rootUrl)Common/GetJson"
        case .getTwilioToken: return "\(RootUrl().rootUrl)Twilio/GetTwilioAccessToken"
        }
    }
}
public enum NWHTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
//MARK:-Global Api Call For Entire App
func ApiCall(requestDict:[String: Any],apiMethod: String,url:String,successCallback:@escaping ([String:AnyObject]?) -> Void, failureCallback:@escaping (_ error:AnyObject?) -> Void) {

    let json: [String: Any] = requestDict
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String
    let tokenId = UserDefaults.standard.value(forKey: UserDefaultsStored.tokenID)
    var headers: HTTPHeaders = [:]
    if let id = tokenId as? String{
       headers    = [ "Authorization" : "Bearer \(id)"]
    }
    showGlobalProgressHUDWithTitle(title: "")
    
    
    
    AF.request(url, method: .post, parameters: ["_Params":jsonString], encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
             print("Response String: \(String(describing: response.value))")
       DispatchQueue.main.async {
        dismissGlobalHUD()
        }
                   switch response.result {
                           case .success(let value):
                            successCallback(value as? [String : AnyObject])
                           case .failure(let error):
                            failureCallback(error as AnyObject)
                           }
    }
}
func ApiCallss(requestDict:[String: Any],apiMethod: String,url:String,successCallback:@escaping ([String:AnyObject]?) -> Void, failureCallback:@escaping (_ error:AnyObject?) -> Void) {

    let json: [String: Any] = requestDict
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String
    let tokenId = UserDefaults.standard.value(forKey: UserDefaultsStored.tokenID)
    var headers: HTTPHeaders = [:]
    if let id = tokenId as? String{
       headers    = [ "Authorization" : "Bearer \(id)"]
    }
    showGlobalProgressHUDWithTitle(title: "")
    AF.request(url, method: .post, parameters: ["_Params":jsonString], encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
             print("Response String: \(String(describing: response.value))")
        DispatchQueue.main.async {
        dismissGlobalHUD()
        }
                   switch response.result {
                           case .success(let value):
                            successCallback(value as? [String : AnyObject])
                           case .failure(let error):
                            failureCallback(error as AnyObject)
                           }
    }
}
func ApiCalls(requestDict:[String: Any],apiMethod: String,url:String,successCallback:@escaping (NSArray) -> Void, failureCallback:@escaping (_ error:AnyObject?) -> Void) {
    let json: [String: Any] = requestDict
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String
    let tokenId = UserDefaults.standard.value(forKey: UserDefaultsStored.tokenID)
    var headers: HTTPHeaders = [:]
    if let id = tokenId as? String{
       headers    = [ "Authorization" : "Bearer \(id)"]
    }
    showGlobalProgressHUDWithTitle(title: "")
    AF.request(url, method: .post, parameters: ["_Params":jsonString], encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
             print("Response String: \(String(describing: response.value))")
        DispatchQueue.main.async {
        dismissGlobalHUD()
        }
                   switch response.result {
                           case .success(let value):
                            successCallback((value as? NSArray)!)
                           case .failure(let error):
                            failureCallback(error as AnyObject)
        }
    }
}
    func AuthGetTokenApiCall(requestDict:[String: Any],apiMethod:
        String,url:String,successCallback:@escaping ([String:AnyObject]?) -> Void, failureCallback:@escaping (_ error:AnyObject?) -> Void) {
     let json: [String: Any] = requestDict
     let jsonData = try? JSONSerialization.data(withJSONObject: json)
     let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String
     let tokenId = UserDefaults.standard.value(forKey: UserDefaultsStored.tokenID)
     var headers: HTTPHeaders = [:]
     if let id = tokenId as? String{
         let token = "Bearer \(id)"
        headers    = [ "Authorization" : token ]
     }
    showGlobalProgressHUDWithTitle(title: "")
     AF.request(url, method: .post, parameters: requestDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
              print("Response String: \(String(describing: response.value))")
      DispatchQueue.main.async {
       dismissGlobalHUD()
       }
                    switch response.result {
                            case .success(let value):
                             successCallback(value as? [String : AnyObject])
                            case .failure(let error):
                             failureCallback(error as AnyObject)
                            }
     }
}
class DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()

    /// Encodes given Encodable value into an array or dictionary
    func encode<T>(_ value: T) throws -> Any where T: Encodable {
        let jsonData = try jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
}

class DictionaryDecoder {
    private let jsonDecoder = JSONDecoder()

    /// Decodes given Decodable type from given array or dictionary
    func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}
struct RootResponse : Decodable {
    var error: ErrorStruct
    var payload: PayloadStruct
    var success: Int
}

struct ErrorStruct: Decodable {
    var code: String
    var message: String
}

struct PayloadStruct : Decodable {
   
}


func showGlobalProgressHUDWithTitle(title: String) -> MBProgressHUD{
    let window:UIWindow = UIApplication.shared.windows.last!
    let hud = MBProgressHUD.showAdded(to: window, animated: true)
    hud.label.text = "Loading..."
//    hud.labelText = title
    //hud.labelFont = UIFont(name: FONT_NAME, size: 15.0)
    return hud
}

func dismissGlobalHUD() -> Void{
    
    let window:UIWindow = UIApplication.shared.windows.last!
    MBProgressHUD.hide(for: window, animated: true)//hideAllHUDsForView(window, animated: true)
}
class AppConstants {
    enum AlertMessage:String {
           case notRegistered  = "You must create an account or sign in to access this feature. Click Yes to proceed."

           case pwdNotMatching = "Password & confirm password are not matching"
           case emailInvalid   = "Invalid email!"
           case userNotRegistered  = "You are not registered with us. Please create an account"
           case passwordNotMatching  = "Password not matching. Please try again"
           case genericError  = "Unexpected error occurred"
           case lesserDate  = "Start time should be less than end time"
           case lessertime  = "Start time should be greater than current time"

           case reminderTypeText  = "Select the reminder type"
           case repeatText  = "Select the repeat type"
           case dobText  = "Please enter your date of birth"

           case enterReminderTitle  = "Please enter reminder title"
           case Benefits  = "Please select Fertility Benefits status."

           case reminderTxt  = "Please enter reminder description"
           case employerTxt   = "Please enter Employer Name"
           case feedbackTxtMissing   = "Please enter Feedback"
           case textMessageTxtMissing   = "Please enter Text Message"
           case commentsTxtMissing   = "Please enter additional features required"
           case notifOptionMissing   = "Please select an option"
           case enterEmail  = "Please enter email address"
           case enterphName  = "Please enter physician name"
           case enterpractise  = "Please enter practise name"

           case enterDuration  = "Please enter duration!"
           case enterFName  = "Please enter first name!"
           case enterLName  = "Please enter last name!"
           case enteraddress  = "Please enter address!"
           case entercity  = "Please enter city!"
           case enterstate  = "Please enter state!"
           case enterzip  = "Please enter zip!"

           case enterPNumb  = "Please enter phone number!"
           case entervalidPNumb  = "Please enter valid phone number"
           case enterPassword  = "Please enter password"
           case enterCurrPwd   = "Please enter current password"
           case enterNewPwd    = "Please enter new password"
           case enterConfPwd   = "Please enter confirm password"
           case pwdMismatch    = "New password and confirm password are not matching"
           case enterDob  = "Please enter DOB"
           case enterGeder  = "Please select gender"
           case validEmail  = "Please enter valid email address"
           case validPassword  = "Password must contain a number, a special character, an upper case letter, a lower case letter and has to be 8 characters in length"

           case enterSubID  = "Please enter Subscriber ID"
           case genericProfileEntry  = "Please enter profile information details"
           case cycleDataEmpty = "If all requested information is not entered, then we will not be able to properly track your menstrual cycle or be able to suggest your peak ovulation time. Are you sure you want to proceed?"
           case genericEntry  = "Please enter any information"
           case passwordchangeSuccess = "Your password has been changed successfully! Thank you."
           case logoutMessage   = "Are you sure you want to logout?"
           case deleteReminder = "Do you want to delete this reminder?"
           case winProgramMessage = "If you would like to speak with one of our Care Coordinators, then please call WINFertility at: 844-447-1231."
           case firstQuest = "Are you Pregnant?"
           case secondQuest = "Do you wish to turn off all further notifications from the App?"
           case employerSponAlert = "If you would like to speak with a WINFertility nurse then please call WINFertility at: (employer toll-free number)"
           case success    = "Successfully Submitted."
           case successEmail    = "Thank you for sending your request to WINFertility. We will contact you at the time you indicated on the form."
           case emailChartSuccess    = "We have received your request. You will shortly get a copy of your fertility chart to the email address provided to us."
           case emailAccumulatorSuccess    = "We have received your request. You will shortly get a copy of your accumulator history to the email address provided to us."
           case feedbackSuccess    = "Thank you for providing us with your feedback. Your input is valuable for us to make improvements to this App. Please check for updates periodically."
           
           case textMessageSuccess    = "Thank you for submitting your text message. Due to the sensitive personal nature of this fertility App, and to ensure your privacy, a representative will contact you at the number you used to create this account within the next business day."
           case requestRefillText    = "Thank you for submitting your Refill Request. Due to the sensitive personal nature of this fertility App, and to ensure your privacy, a representative will contact you at the number you used to create this account within the next business day."
           case helpUsSuccess    = "Thank you for submitting your employer information. We are constantly updating our network and will reach out to your employer to see if they want to participate. In the meantime you may find this information useful http://go.winfertility.com/benefits"
           case linkUrl = "http://go.winfertility.com/benefits"
           case imageCropperWarning  = "Are you sure want to move out of the page?"
           case cameraNotAvilable  = "Camera not available"
           case benefitsOverviewEmpty = "Please call us at 844-447-1231 to take advantage of WINFertility program and special pricing"
           case notificationON = "Do you want to Turn ON Notifications?"
           case notificationOFF = "Do you want to Turn OFF Notifications?"
           case startPeriodDateErr = "Your last period date cannot be greater the current date"
           case priceQuoteDone = "Thank you for sending your request to WINFertilityRx. \n\nWe will review your information submitted and will provide a quote. \n\n Should you require immediate assistance, our WINFertilityRx Specialists Team is available Monday – Friday, 8:30 AM - 7:30 PM EST."
           case emailQuote = "We have received your request. Your medication price quote will be emailed to you shortly."
           case rxMessage = "If this is an urgent request, please call WINFertility directly.  All other requests will be processed during normal business hours"
           case uploadAlert = "Please upload files/images only with the following formats .pdf,.jpg,.jpeg,.png or .bmp"
       }
       
}
