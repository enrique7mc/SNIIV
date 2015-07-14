//
//  Utils.swift
//  SNIIV
//
//  Created by admin on 13/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

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
}
