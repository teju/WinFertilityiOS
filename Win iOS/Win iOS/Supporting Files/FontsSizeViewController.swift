//
//  FontsSizeViewController.swift
//  Win iOS
//
//  Created by BALARAM SOMINENI on 07/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit


//MARK: - UILabel Extension For Font Size, it will change based on the screen size.
extension UILabel {
    func forNormalLabel() {
        self.font = self.font.withSize(screenWidth*0.04)
        print(screenWidth*0.04)
        self.sizeToFit()
    }
    func forTitleLabel() {
        self.font = self.font.withSize(screenWidth*0.049)
        print(screenWidth*0.049)
        self.sizeToFit()
    }
    func forHomeScreenLabel() {
        self.font = self.font.withSize(screenWidth*0.08)
        self.sizeToFit()
    }
    func forHomeScreenMenuLabel() {
        self.font = self.font.withSize(screenWidth*0.0240)
        print("Home Menu \(screenWidth*0.06)")
        self.sizeToFit()
    }
}

//MARK: -  screen Width is returing screen Width
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

//MARK: - extension for string to validate email ID
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
