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
    
    func decimalFormat(numero: Int64) -> String {
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return numberFormatter.stringFromNumber(NSNumber(longLong: numero))!
    }
}
