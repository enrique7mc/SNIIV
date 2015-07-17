//
//  Utils.swift
//  SNIIV
//
//  Created by admin on 13/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SWXMLHash

class Utils {
    let numberFormatter = NSNumberFormatter()
    
    func decimalFormat(numero: NSNumber) -> String {
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter.stringFromNumber(numero)!
    }
    
    static func toString(numero: Int64?, divide: Int = 1000) -> String {
        if let num = numero {
            return Utils().decimalFormat(Double(num) / Double(divide))
        }
        
        return "-"
    }
    
    static func toString(numero: Double) -> String {
        return Utils().decimalFormat(numero)
    }
    
    static func getText(value: AnyObject!) -> String {
        if let object: AnyObject = value {
            return object as! String
        } else {
            return ""
        }
    }
    
    static func parseInt(string: String) -> Int{
        var number = string.toInt()
        if let n = number {
            return n
        } else {
            return 0
        }
    }
    
    static func parseInt64(string: String) -> Int64{
        let strAsNSString = string as NSString
        return strAsNSString.longLongValue
    }
    
    static func getText(indexer: XMLIndexer) -> String {
        if let element = indexer.element, text = element.text {
            return text;
        } else {
            return "";
        }
    }
}
