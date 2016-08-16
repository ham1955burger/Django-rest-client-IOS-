//
//  extension.swift
//  PhotoTest
//
//  Created by ouniwang on 8/12/16.
//  Copyright © 2016 ouniwang. All rights reserved.
//

import Foundation


extension String {
    func stateHABString() -> String {
        switch self {
            case "receive":
            return "입금"
            
            case "pay":
            return "출금"
            
        default:
            return ""
        }
    }
    
    func categoryToString() -> String {
        switch self {
            case "salary":
            return "월급"
            
            case "foodExpenses":
            return "식비"
            
            case "default":
            return "기타"
        
        default:
            return ""
        }
    }
    
    func stringToCategory() -> String {
        switch self {
            case "월급":
                return "salary"
            case "식비":
                return "foodExpenses"
            case "기타":
                return "default"
        default:
            return ""
        }
    }
}


extension UIViewController {
    func oneButtonAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController.init(title: "", message: message, preferredStyle: .Alert)
        let confirmButton = UIAlertAction.init(title: "확인", style: .Default, handler: nil)
        let confirmButtonWithAction = UIAlertAction.init(title: "확인", style: .Default, handler: handler)
        
        if handler != nil {
            alert.addAction(confirmButtonWithAction)
        } else {
            alert.addAction(confirmButton)
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}