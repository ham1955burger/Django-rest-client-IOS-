//
//  extension.swift
//  PhotoTest
//
//  Created by ouniwang on 8/12/16.
//  Copyright © 2016 ouniwang. All rights reserved.
//

import Foundation


extension String {
    func stateHABString() -> String{
        switch self {
            case "receive":
            return "입금"
            
            case "pay":
            return "출금"
            
        default:
            return ""
        }
    }
}