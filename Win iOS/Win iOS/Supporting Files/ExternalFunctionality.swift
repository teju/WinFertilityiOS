//
//  ExternalFunctionality.swift
//  Win iOS
//
//  Created by ISE10121 on 23/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit


protocol ToolbarPickerViewDelegate: class {
    func didTapDone()
    func didTapCancel()
}

class ToolbarPickerView: UIPickerView {

    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: ToolbarPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor.fromHexaString(hex: "16284C")
        UINavigationBar.appearance().barTintColor = UIColor.clear
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        doneButton.tintColor = UIColor.fromHexaString(hex: "94D60A")
        
        doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Graphie-Regular", size: 22)!,
            NSAttributedString.Key.foregroundColor : UIColor.fromHexaString(hex: "94D60A"),
        ], for: .normal)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        spaceButton.tintColor = UIColor.fromHexaString(hex: "94D60A")
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))
        cancelButton.tintColor = UIColor.fromHexaString(hex: "94D60A")
         cancelButton.setTitleTextAttributes([
                   NSAttributedString.Key.font : UIFont(name: "Graphie-Regular", size: 22)!,
                   NSAttributedString.Key.foregroundColor : UIColor.fromHexaString(hex: "94D60A"),
               ], for: .normal)

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone()
    }

    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel()
    }
}
class DateToolbarPickerView: UIDatePicker {

    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: ToolbarPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor.fromHexaString(hex: "16284C")
        UINavigationBar.appearance().barTintColor = UIColor.clear
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        doneButton.tintColor = UIColor.fromHexaString(hex: "94D60A")
        
        doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Graphie-Regular", size: 22)!,
            NSAttributedString.Key.foregroundColor : UIColor.fromHexaString(hex: "94D60A"),
        ], for: .normal)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        spaceButton.tintColor = UIColor.fromHexaString(hex: "94D60A")
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))
        cancelButton.tintColor = UIColor.fromHexaString(hex: "94D60A")
         cancelButton.setTitleTextAttributes([
                   NSAttributedString.Key.font : UIFont(name: "Graphie-Regular", size: 22)!,
                   NSAttributedString.Key.foregroundColor : UIColor.fromHexaString(hex: "94D60A"),
               ], for: .normal)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone()
    }

    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel()
    }
}
func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
    var chars = Array(myString)     // gets an array of characters
    chars[index] = newChar
    let modifiedString = String(chars)
    return modifiedString
}
extension UIColor
{
    class func fromHexaString(hex:String) -> UIColor
    {
        let scanner           = Scanner(string: hex)
        scanner.scanLocation  = 0
        var rgbValue: UInt64  = 0
        scanner.scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension UIButton {

    func drawBorder(edges: [UIRectEdge], borderWidth: CGFloat, color: UIColor) {
        for item in edges {
            let borderLayer: CALayer = CALayer()
            borderLayer.borderColor = color.cgColor
            borderLayer.borderWidth = borderWidth
            switch item {
            case .top:
                borderLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: borderWidth)
            case .left:
                borderLayer.frame =  CGRect(x: 0, y: 0, width: borderWidth, height: frame.height)
            case .bottom:
                borderLayer.frame = CGRect(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth)
            case .right:
                borderLayer.frame = CGRect(x: frame.width - borderWidth, y: 0, width: borderWidth, height: frame.height)
            case .all:
                drawBorder(edges: [.top, .left, .bottom, .right], borderWidth: borderWidth, color: color)
            default:
                break
            }
            self.layer.addSublayer(borderLayer)
        }
    }
}
func randomString(startInt: Int, endInt: Int) -> [String] {
    var out = [String]()
    for i in startInt ..< endInt + 1{
        out.append("\(i)")
    }
    return out
}

extension UITextField {

    func addInputViewDatePicker(target: Any, selector: Selector, maxDate: Date?, minDate: Date?, datePickerMode: UIDatePicker.Mode) {

    let screenWidth = UIScreen.main.bounds.width

    //Add DatePicker as inputView
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    datePicker.datePickerMode = datePickerMode
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
    datePicker.backgroundColor = UIColor.fromHexaString(hex: "0A182B")
    datePicker.setValue(UIColor.white, forKeyPath: "textColor")
    self.inputView = datePicker
    //Add Tool Bar as input AccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    toolBar.barTintColor = UIColor.fromHexaString(hex: "16284C")
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    flexibleSpace.tintColor = UIColor.fromHexaString(hex: "94D60A")
    let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
    cancelBarButton.tintColor = UIColor.fromHexaString(hex: "94D60A")
    cancelBarButton.setTitleTextAttributes([
        NSAttributedString.Key.font : UIFont(name: "Graphie-Regular", size: 22)!,
        NSAttributedString.Key.foregroundColor : UIColor.fromHexaString(hex: "94D60A"),
    ], for: .normal)
    let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
    doneBarButton.tintColor = UIColor.fromHexaString(hex: "94D60A")
    doneBarButton.setTitleTextAttributes([
        NSAttributedString.Key.font : UIFont(name: "Graphie-Regular", size: 22)!,
        NSAttributedString.Key.foregroundColor : UIColor.fromHexaString(hex: "94D60A"),
    ], for: .normal)
    toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

    self.inputAccessoryView = toolBar
 }

   @objc func cancelPressed() {
     self.resignFirstResponder()
   }
}

extension UITextField {
    func loadDropdownData(data: [String]) {
        self.inputView = MyPickerView(pickerData: data, dropdownField: self)
    }
}
class MyPickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate {
    func didTapDone() {
        
    }
    func didTapCancel() {
        
    }
    var pickerData : [String]!
    var pickerTextField : UITextField!
    
    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: ToolbarPickerViewDelegate?
   
    init(pickerData: [String], dropdownField: UITextField) {
        super.init(frame: CGRect.zero)
        self.pickerData = pickerData
        self.pickerTextField = dropdownField
        self.backgroundColor = UIColor.fromHexaString(hex: "0A182B")
        self.delegate = self
        self.dataSource = self
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                let toolBar = UIToolbar()
                       toolBar.barStyle = UIBarStyle.default
                       toolBar.barStyle = UIBarStyle.default
                       toolBar.isTranslucent = true
                       toolBar.barTintColor = UIColor.fromHexaString(hex: "16284C")
                       UINavigationBar.appearance().barTintColor = UIColor.clear
                       toolBar.sizeToFit()

                       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
                       doneButton.tintColor = UIColor.fromHexaString(hex: "94D60A")
                       
                       doneButton.setTitleTextAttributes([
                           NSAttributedString.Key.font : UIFont(name: "Graphie-Regular", size: 22)!,
                           NSAttributedString.Key.foregroundColor : UIColor.fromHexaString(hex: "94D60A"),
                       ], for: .normal)
                       let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                       spaceButton.tintColor = UIColor.fromHexaString(hex: "94D60A")
                       let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))
                       cancelButton.tintColor = UIColor.fromHexaString(hex: "94D60A")
                        cancelButton.setTitleTextAttributes([
                                  NSAttributedString.Key.font : UIFont(name: "Graphie-Regular", size: 22)!,
                                  NSAttributedString.Key.foregroundColor : UIColor.fromHexaString(hex: "94D60A"),
                              ], for: .normal)

                       toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
                       toolBar.isUserInteractionEnabled = true

                self.toolbar = toolBar
                self.pickerTextField.inputAccessoryView = self.toolbar
            if pickerData.count != 0 {
                self.pickerTextField.text = self.pickerData[0]
                self.pickerTextField.isEnabled = true
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.isEnabled = false
            }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    @objc func doneTapped() {
        self.pickerTextField.endEditing(true)
       }

       @objc func cancelTapped() {
        self.pickerTextField.endEditing(true)
       }

     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
     func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
         pickerView.subviews[1].backgroundColor = UIColor.lightGray
         pickerView.subviews[2].backgroundColor = UIColor.lightGray
         let pickerLabel = UILabel()
         pickerLabel.textColor = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.white : UIColor.white
         pickerLabel.font = UIFont(name: "Graphie-Regular", size: 22)
         pickerLabel.text = pickerData[row]
         pickerLabel.textAlignment = NSTextAlignment.center
         return pickerLabel
     }
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
 
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerData[row]
    }
}
extension Date {
    func add(_ unit: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(byAdding: unit, value: value, to: self)
    }
    func isSameDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedSame
    }
    
    func isBeforeDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedAscending
    }
    
    func isAfterDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedDescending
    }
}
 //MARK: - Mutable String In Notes And Alerts View Controller
extension NSMutableAttributedString {
    @discardableResult func bolds(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)

        return self
    }

    @discardableResult func normals(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)

        return self
    }
}

//MARK: - Tableview empty list message
extension UIScrollView {
    func showEmptyListMessage(_ message:String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.sizeToFit()

        if let `self` = self as? UITableView {
            self.backgroundView = messageLabel
            self.separatorStyle = .none
        } else if let `self` = self as? UICollectionView {
            self.backgroundView = messageLabel
        }
    }
}
extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents) ?? nil
    }
}
extension UINavigationController {
    func backToViewController(viewController: Swift.AnyClass) {
            for element in viewControllers as Array {
                if element.isKind(of: viewController) {
                    self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
class CustomTextView:UITextView{

   var rightimageview : UIImageView?
     @IBInspectable var rightImage : UIImage? {
            didSet {
                if rightImage != nil {
                    let width = rightviewWidth > rightImage!.size.width ? rightviewWidth :  rightImage!.size.width
                 // rightViewMode = UITextView.ContentMode.center
                    rightimageview = UIImageView()
                    rightimageview!.frame = CGRect(x: self.frame.size.width - width, y: self.frame.origin.y+2, width: width,height: self.frame.size.height-4)
                    rightimageview!.image = rightImage
                   // rightView = rightimageview
                    //self.rightViewMode = .always
                    rightimageview!.contentMode = .center
                }
                else {
                    if rightimageview != nil {
                        rightimageview?.removeFromSuperview()
                        rightimageview = nil
                    }
                }
            }
        }
      @IBInspectable var rightviewWidth : CGFloat = 0 {
             didSet{
                 if rightimageview != nil{
                     let width = rightviewWidth > rightImage!.size.width + 10 ? rightviewWidth :  rightImage!.size.width + 10
                     rightimageview!.frame = CGRect(x: self.frame.origin.x+5, y: self.frame.origin.y+2, width: width,height: self.frame.size.height-4)
                 }
             }
      }
}
extension String {

    func removingAllWhitespaces() -> String {
        return removingCharacters(from: .whitespaces)
    }

    func removingCharacters(from set: CharacterSet) -> String {
        var newString = self
        newString.removeAll { char -> Bool in
            guard let scalar = char.unicodeScalars.first else { return false }
            return set.contains(scalar)
        }
        return newString
    }
}
func validateEmail(email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
}
func isPasswordValid(_ password : String) -> Bool{
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
    return passwordTest.evaluate(with: password)
}
public enum BorderSide {
    case top, bottom, left, right
}

extension UIButton {
    public func addBorder(side: BorderSide, color: UIColor, width: CGFloat) {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        self.addSubview(border)

        let topConstraint = topAnchor.constraint(equalTo: border.topAnchor)
        let rightConstraint = trailingAnchor.constraint(equalTo: border.trailingAnchor)
        let bottomConstraint = bottomAnchor.constraint(equalTo: border.bottomAnchor)
        let leftConstraint = leadingAnchor.constraint(equalTo: border.leadingAnchor)
        let heightConstraint = border.heightAnchor.constraint(equalToConstant: width)
        let widthConstraint = border.widthAnchor.constraint(equalToConstant: width)


        switch side {
        case .top:
            NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, heightConstraint])
        case .right:
            NSLayoutConstraint.activate([topConstraint, rightConstraint, bottomConstraint, widthConstraint])
        case .bottom:
            NSLayoutConstraint.activate([rightConstraint, bottomConstraint, leftConstraint, heightConstraint])
        case .left:
            NSLayoutConstraint.activate([bottomConstraint, leftConstraint, topConstraint, widthConstraint])
        }
    }
}
extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}


struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}
