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
    static let WEB_SERVICE_URL = "http://www.conavi.gob.mx:8080"
    
    static let numberFormatter = NSNumberFormatter()
    static let dateFormatter = NSDateFormatter()

    
    static func decimalFormat(numero: NSNumber) -> String {
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter.stringFromNumber(numero)!
    }
    
    static func toStringDivide(numero: Int64?, divide: Int = 1000) -> String {
        if let num = numero {
            return decimalFormat(Double(num) / Double(divide))
        }
        
        return "-"
    }
    
    static func toStringDivide(numero: Double?, divide: Int = 1000) -> String {
        if let num = numero {
            return decimalFormat(Double(num) / Double(divide))
        }
        
        return "-"
    }
    
    static func toString(numero: Double) -> String {
        return decimalFormat(numero)
    }
    
    static func toString(numero: Int64) -> String {
        return decimalFormat(NSNumber(longLong: numero))
    }
    
    static func getText(value: AnyObject?) -> String {
        if let object: AnyObject = value {
            return object as! String
        } else {
            return ""
        }
    }
    
    static func getNSNumber(value: AnyObject?) -> NSNumber {
        return value as! NSNumber
    }
    
    static func parseInt(string: String) -> Int{
        var number = string.toInt()
        if let n = number {
            return n
        } else {
            return 0
        }
    }
    
    static func parseInt64(string: String) -> Int64 {
        let strAsNSString = string as NSString
        return strAsNSString.longLongValue
    }
    
    static func parseDouble(string: String) -> Double {
        let strAsNSString = string as NSString
        return strAsNSString.doubleValue
    }
    
    static func getText(indexer: XMLIndexer) -> String {
        if let element = indexer.element, text = element.text {
            return text;
        } else {
            return "";
        }
    }
    
    static func equalDays(date1: String, date2: String) -> Bool {
        return date1 == date2
    }
    
    static func CurrentDateAsString() -> String {
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.stringFromDate(NSDate())
    }
    
    static let entidades = ["Nacional","Aguascalientes", "Baja California", "Baja California Sur", "Campeche", "Coahuila", "Colima", "Chiapas" , "Chihuahua", "Distrito Federal", "Durango", "Guanajuato", "Guerrero","Hidalgo", "Jalisco",
        "México", "Michoacán", "Morelos", "Nayarit", "Nuevo León" , "Oaxaca", "Puebla", "Querétaro", "Quintana Roo", "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala", "Veracruz", "Yucatán", "Zacatecas"]
    
    static func Sumar(a: Int64, b: Int64) -> Int64 {
        return a + b
    }
    
    static func Sumar(a: Double, b: Double) -> Double {
        return a + b
    }
    
    static func formatoDiaMes(fecha: String) -> String {
        return formatoFecha(fecha, formato: "d MMMM yyyy").capitalizedString
    }
    
    static func formatoMes(fecha: String) -> String {
        return formatoFecha(fecha, formato: "MMMM yyyy").capitalizedString
    }
    
    static func formatoFecha(fecha: String, formato: String) -> String {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.dateFromString(fecha)
        if date != nil {
            dateFormatter.dateFormat = formato
            dateFormatter.locale = NSLocale(localeIdentifier: "es-MX")
            return dateFormatter.stringFromDate(date!)
        }
        
        return fecha
    }

}
